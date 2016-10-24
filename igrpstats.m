% Generalzied: [row2group,grouplabels,group2row]= igrpstats(x,group)
%
% Extraction of Mathworks code from 2016A
%
% All copyrights to Mathworks
function  [row2group,grouplabels,group2row,groupnames]= igrpstats(x,group)

[rows,cols] = size(x);

if (nargin<1)
   error(message('stats:igrpstats:TooFewInputs'))
elseif isa(x,'dataset') || isa(x,'table')
    if nargin<2, group=[]; end
     [row2group,grouplabels,group2row,groupnames] = dsgrpstats(x,group,[]);
    return
end
assert('Same as the other, but not tested');


% Get grouping variable information
if (nargin<2) || isempty(group)
   group = ones(rows,1);
end

[group,glabel,groupname] = internal.stats.mgrp2idx(group,rows);
if length(group) ~= rows
    error(message('stats:grpstats:InputSizeMismatch'));
end

% Find the indices of each group. 
rowvec = (1:rows)';
groups = accumarray( group(~isnan(group)), rowvec(~isnan(group)), [], @(x){x}); 

row2group = group;
group2row = groups;
grouplabels = glabel;
groupnames = groupname;

function [ogroup,glabel,gname,multigroup,maxgroup] = mgrp2idx_old(group,rows,sep)
%MGRP2IDX Convert multiple grouping variables to index vector
%   [OGROUP,GLABEL,GNAME,MULTIGROUP,MAXGROUP] = MGRP2IDX(GROUP,ROWS)
%   takes the inputs GROUP, ROWS, and SEP.  GROUP is a grouping variable
%   (categorical variable, numeric vector, numeric matrix, string matrix, or
%   cell array of strings) or a cell array of grouping variables.  ROWS is the
%   number of observations.  SEP is a separator for the grouping variable
%   values.
%
%   The output OGROUP is a vector of group indices.  GLABEL is a cell
%   array of group labels, each label consisting of the values of the
%   various grouping variables separated by the characters in SEP.
%   GNAME is a cell array containing one column per grouping variable
%   and one row for each distinct combination of grouping variable
%   values.  MULTIGROUP is 1 if there are multiple grouping variables
%   or 0 if there are not.  MAXGROUP is the number of groups before any
%   unused categories are omitted.

%   Copyright 1993-2006 The MathWorks, Inc.
%   $Revision: 1.4.2.5 $  $Date: 2006/11/11 22:57:34 $

multigroup = (iscell(group) && size(group,1)==1) ||...
    (isnumeric(group) && ~isvector(group) && ~isempty(group));
if (~multigroup)
    [ogroup,gname,maxgroup] = grp2idx(group);
    glabel = gname;
else
    % Group according to each distinct combination of grouping variables
    ngrps = size(group,2);
    grpmat = zeros(rows,ngrps);
    namemat = cell(1,ngrps);

    % Get integer codes and names for each grouping variable
    if iscell(group)
        for j=1:ngrps
            [g,gn] = grp2idx(group{1,j});
            if (size(g,1)~=rows)
                error('stats:mgrp2idx:InputSizeMismatch',...
                      'All grouping variables must have %d rows.',rows);
            end
            grpmat(:,j) = g;
            namemat{1,j} = gn;
        end
    else
        for j=1:ngrps
            [g,gn] = grp2idx(group(:,j));
            grpmat(:,j) = g;
            namemat{1,j} = gn;
        end
    end;

    % Find all unique combinations
    wasnan = any(isnan(grpmat),2);
    grpmat(wasnan,:) = [];
    [urows,ui,uj] = unique(grpmat,'rows');
    % Create a cell array, one col for each grouping variable value
    % and one row for each observation
    ogroup = NaN(size(wasnan));
    ogroup(~wasnan) = uj;
    gname = cell(size(urows));

    for j=1:ngrps
        gn = namemat{1,j};
        gname(:,j) = gn(urows(:,j));
    end

    % Create another cell array of multi-line texts to use as labels
    glabel = cell(size(gname,1),1);
    if (nargin > 2)
        nl = sprintf(sep);
    else
        nl = sprintf('\n');
    end
    fmt = sprintf('%%s%s',nl);
    lnl = length(fmt)-3;        % one less than the length of nl
    for j=1:length(glabel)
        gn = sprintf(fmt, gname{j,:});
        gn(end-lnl:end) = [];
        glabel{j,1} = gn;
    end
    maxgroup = length(glabel);
end
end

function [group,glabel,groups,groupname] = dsgrpstats(a,groupvars,whichstats,varargin)
%   Copyright 2006-2014 The MathWorks, Inc. 

if isa(a,'dataset')
    a = dataset2table(a);
else
end

[a_nobs,a_nvars] = size(a);
a_data = getvars(a);

groupvars = getvarindices(a,groupvars,false);
[group,glabel,groupname] = internal.stats.mgrp2idx(a_data(groupvars),a_nobs);

% Find indices of each group
rowvec = (1:a_nobs)';
groups = accumarray( group(~isnan(group)), rowvec(~isnan(group)), [], @(x){x}); 

end

% Nested functions below here; they use alpha from caller
    % ----------------------------
    function ci = meanci(y)
    n = size(y,1);
    m = mean(y,1);
    s = std(y,0,1) ./ sqrt(n);
    d = s .* -tinv(alpha/2, max(0,n-1));
    ci = [m-d;m+d];
    end

    % ----------------------------
    function ci = predci(y)
    n = size(y,1);
    m = mean(y,1);
    s = std(y,0,1) .* sqrt(1 + 1./n);
    d = s .* -tinv(alpha/2, max(0,n-1));
    ci = [m-d;m+d];
    end

    % ----------------------------
    function m = empty2NaN(m) % convert 0xm empty to NaN(1,m)
    if size(m,1) == 0
        m = NaN(1,size(m,2));
    end
    end
end

% -----------------------------------------
% Permute the row dimension to the end
function val = permuteToTrailing(val,sz)
if prod(sz(2:end)) == 1
    % transpose a column vector
    val = val';
else
    % or do a genuine permute for a matrix or N-D array
    d = ndims(val);
    val = permute(val,[d+1 2:d 1]);
end
end


function varIndices = getvarindices(a,varIndices,~)
if islogical(varIndices)
    varIndices = find(varIndices);
elseif ischar(varIndices) || iscellstr(varIndices)
    if ischar(varIndices)
        varNames = cellstr(varIndices);
    else
        varNames = varIndices;
    end
    [~,varIndices] = ismember(varNames,a.Properties.VariableNames);
    if any(varIndices==0)
        j = find(varIndices==0,1,'first');
        error(message('stats:dataset:getvarindices:UnrecognizedVarName', varNames{j}));
    end
%     varIndices = zeros(1,numel(varNames));
%     for j = 1:numel(varIndices)
%         varIndex = find(strcmp(varNames{j},get(a,'VarNames')));
%         if isempty(varIndex)
%             error(message('stats:dataset:getvarindices:UnrecognizedVarName', varNames{j}));
%         end
%         varIndices(j) = varIndex;
%     end
end
end

function vars = getvars(a)
names = a.Properties.VariableNames;
vars = cell(1,length(names));
for i = 1:length(vars)
    vars{i} = a.(names{i});
end
end

