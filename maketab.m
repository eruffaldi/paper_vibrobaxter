function r = maketab(X,n)


if nargin == 1 && isstruct(X)
    if length(X) == 1
        f = fieldnames(X);
        r = table();
        for I=1:length(f)
            v =  X.(f{I});
            if size(v,1) == 1
                v = v';
            end
            r.(f{I}) =v;
        end
    else
        q = squeeze(struct2cell(X)); % fields x rows
        f = fieldnames(X);
        r = table();
        for I=1:size(f,1)
            v =  q(I,:);
            if size(v,1) == 1
                v = v';
            end
            r.(f{I}) =v;
        end
    end
else
    if nargin == 1 && iscell(X) && isstruct(X{1})
        s = X{1};
        f = fieldnames(s);
        Y = cell(length(X),length(f));
        for I=1:length(X)
            v = X{I};
            for J=1:length(f)
                Y{I,J} = v.(f{J});
            end
        end
        r = maketab(Y,f);
    else
        if iscell(n) == 0
            n = cellstr(n);
        end
        r = table();
        for I=1:length(n)
            r.(n{I}) = X(:,I);
        end
    end
    
end