function cstats= autostat(t,model)
cstats = [];
% Preparatory Phase with Basic Verifications
s = properties(t);
st = cell2struct(cell(length(s),1),s);

assert(isfield(st,'user'),'user field required');
assert(isfield(st,'group'),'group field required');

nu = unique(t.user);
ng = unique(t.group);
ri = model.subjectsession;

% fix
if iscell(t.(ri))
    t.(ri) = cell2mat(t.(ri));
end

% fix Categorization
t.group = categorical(t.group);
t.user = categorical(t.user);
t.iuser = double(t.user);

% targets
targetnames = cellfun(@(x) x{1}, model.targets,'UniformOutput',false);
transforms = cell(size(targetnames));
invtargetnames = [];
for I=1:length(model.targets)
    if strcmp(targetnames{I},'duration')
        targetnames{I} = 'duration';
        t.(targetnames{I}) = (t.(targetnames{I}));
    end
    if 1==1
        if 0 && strcmp(model.targets{I}{2},'pct')        
            t.(targetnames{I}) = asin(0.01*t.(targetnames{I}));
            transforms{I} = { @asin, @(x) 100*sin(x)};
        elseif model.nolog==0 && strcmp(model.targets{I}{2},'pct')        % HERE
            t.(targetnames{I}) = log10(t.(targetnames{I})+0.01);
            transforms{I} = { @log10, @(x) (10.^x)-0.01};
        end
    end
    invtargetnames.(targetnames{I}) = I;
end

% TODO: semantically move targets to good scans:
% - log for positive

% Then let's estimate groups
gu = grpstats(t,'group',@numel,'DataVars',{'iuser'});

% VERIFY
w_userdisparity = any(diff(gu.GroupCount) ~= 0); 

assert(w_userdisparity == 0,'Unbalanced not supported');

% Understand if within-group or between-subjects
% within-group = one condition per group
[g_rows2group,g_labels,g_group2rows, g_groupnames] = igrpstats(t,'group');
[gc_rows2group,gc_labels,gc_group2rows, gc_groupnames] = igrpstats(t,model.conditions);
betweengroups = 1;
num_conditions = length(gc_group2rows);

for I=1:length(gc_labels)
    g = unique(t.group(gc_group2rows{I}));
    if length(g) > 1
        betweengroups = 0;
        break;
    end
end



assert(betweengroups == 0,'Between Groups not implemented');

conditionvalues = {};
for I=1:length(model.conditions)
    conditionvalues{I} = t.(model.conditions{I});
end

% VERIFY IF THERE IS difference between subjectsession
outs = {};
outp = [];
for I=1:length(model.targets)
    for J=1:length(gc_group2rows)
        y = t.(targetnames{I})(gc_group2rows{J});
        x = t.(model.subjectsession)(gc_group2rows{J});
        
        p = anova1(double(y),double(x),'off');
        if p < 0.05
            w = cell2struct(gc_labels(J),model.conditions);
            outs = [outs; { targetnames{I}, gc_labels{J}, w}];
            outp = [outp; p];
        end
        
    end
    % hypothesis x and y differ
end
if length(outp) > 0
    warning('Relative Session Effect');
    disp('All Targets')
    targetnames
    disp('Cases for which there is some effect')
        outp
        outs
end
    

if w_userdisparity == 0
    outs = [];
    outs.target = {};
    %outs.condition = {};
    outs.stats = {};
    outs.p = [];
    for I=1:length(model.targets)
        y = t.(targetnames{I});
        if(size(y,2) > 1)
            y = mean(y,2); % TODO MANOVA
        end
        if length(model.conditions) == 1
            [p,xt,stats] = anova1(double(y),t.(model.conditions{1}),'off');
        else
            [p,xt,stats] = anovan(double(y),conditionvalues,'model','interaction','varnames',model.conditions);
        end
        outs.target{end+1} = targetnames{I};
        %outs.condition{end+1} = model.conditions;
        outs.stats{end+1} = stats;
        outs.p(end+1) = p;
    end
    cstats = maketab(outs);
    
end

% FINALLY PLOT
close all
%conditionvalues_withg =[{t.group},conditionvalues];
%conditions_withg = [{'group'} model.conditions];
for I=1:length(model.errorplots)
    vv = model.errorplots{I};
    vvsafe = cellfun(@(x) strrep(x,'_','-'),vv,'UniformOutput',false);
    figure;
    assert(length(model.conditions) == 1,'only one param dim supported');
    MV = zeros(length(gc_group2rows),length(vv),1);
    eV = zeros(length(gc_group2rows),length(vv),2);
    for K=1:length(vv)
        w = vv{K};
        n =height(t);
        for J=1:length(gc_group2rows)
            MV(J,K) = mean(t.(w)(gc_group2rows{J}));

            eV(J,K,1) = std(t.(w)(gc_group2rows{J}))/n*1.96; % std error
            eV(J,K,2) = eV(J,K,1);
        end
        if ~isempty(transforms{invtargetnames.(w)})
            % inverse
            ifx = transforms{invtargetnames.(w)}{2};
            oMV = MV;
            MV(:,K) = ifx(oMV(:,K));
            % do bias in transformed, back transform, deapply mean
            eV(:,K,1) = ifx(oMV(:,K)+eV(:,K,1))-MV(:,K);
            eV(:,K,2) = ifx(oMV(:,K)-eV(:,K,2))-MV(:,K);
        end
    end

    h = barwitherr(eV,MV);
    ylabel('Values');
    set(gca,'XTickLabel',gc_groupnames);
    legend(vvsafe);
end
 
 conditionvalues_withg =[{t.group},conditionvalues];
 for I=1:length(model.targets)
     
     figure;
     w = model.targets{I};
     w = w{1};
     if size(t.(w),2) > 1
         boxplot(mean(t.(w),2),conditionvalues_withg);
     else
        boxplot(t.(w),conditionvalues_withg);
    end
    % TODO ylabel
    title(sprintf('Target %s (with group)',strrep(w,'_','-')));
end
% power effect
