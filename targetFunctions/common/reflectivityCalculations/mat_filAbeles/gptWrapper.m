function ref = gptWrapper(q, N, layers_thick, layers_rho, layers_sig);


for i = 1:length(q)
    ref(i) = abeles_reflect_gpt(q(i), N, layers_thick, layers_rho, layers_sig);
end


end