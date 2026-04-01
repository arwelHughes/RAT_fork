

cumX(1) = rL(1,1);
for i = 2:size(rL,1)
    thisX = rL(i,1);
    cumX(i) = cumX(i-1) + thisX;
end




