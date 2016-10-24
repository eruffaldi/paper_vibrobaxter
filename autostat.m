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

for I=1:length(model.targets)
    if strcmp(targetnames{I},'duration')
        targetnames{I} = 'duration';
        t.(targetnames{I}) = (t.(targetnames{I}));
    end
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
[gc_rows2group,gc_labels,gc_group2rows, gc_groupnames] = igrpstats(t,model.conditions);
betweengroups = 1;

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
    title(sprintf('Target %s',strrep(w,'_','-')));
end

conditionvalues_withg =[{t.group},conditionvalues];
for I=1:length(model.targets)
    
    figure;
    w = model.targets{I};
    w = w{1};
    if size(t.(w),2) > 1
        boxplot(mean(t.(w),2),conditionvalues);
    else
        boxplot(t.(w),conditionvalues);
    end
    % TODO ylabel
    title(sprintf('Target %s (with group)',strrep(w,'_','-')));
end
% power effect
