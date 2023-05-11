function R = abeles_reflect(q,layers)

if coder.target('MATLAB')
    R = ones(length(q),1);
else


    coder.cinclude('abeles_reflect.h');

    N = size(layers,1);

    R = zeros(length(q));
    R_out = 0;
    thick = layers(:,1);
    sld = layers(:,2);
    rough = layers(:,3);

    for i = 1:length(q)
        this_q = q(i);
        coder.ceval('abeles_reflect',this_q,N,thick,sld,rough,coder.wref(R_out));
        R(i) = R_out;
    end

end

end
