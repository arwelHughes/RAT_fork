function R = abelesReflectWrapper(q,layers)

if coder.target('MATLAB')
    R = ones(length(q),1);
else
    source1 = ('abeles_reflect.c');
    coder.cinclude('abeles_reflect.h');
    coder.updateBuildInfo('addSourceFiles',source1)

    N = size(layers,1);

    R = zeros(length(q));
    R_out = [0,0];
    thick = layers(:,1);
    sld = layers(:,2);
    rough = layers(:,3);

    for i = 1:length(q)
        this_q = q(i);
        coder.ceval('abeles_reflect',this_q,int32(N),coder.ref(thick),coder.ref(sld),coder.ref(rough),coder.wref(R_out));
        R(i) = R_out(1);
    end
end

end
