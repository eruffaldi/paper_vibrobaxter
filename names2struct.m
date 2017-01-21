function y= names2struct(x,off)

y = [];
for I=1:length(x)
    y.(x{I}) = I+off;
end
