function R = abeles_reflect(q,layers)

if coder.target('MATLAB')
    R = ones(length(q),1);
else


    coder.cinclude('abeles_reflect.h');

    N = size(layers,1);

    R = zeros(length(q));
    R_out = 0;
    for i = 1:length(q)
        this_q = q(i);
        coder.ceval('abeles_reflect',this_q,N,layers,coder.wref(R_out));
        R(i) = R_out;
    end

end

end
