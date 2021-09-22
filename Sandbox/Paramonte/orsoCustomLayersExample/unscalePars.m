
function problem = unscalePars(problem) 

limits = problem.fitconstr;     % These are the original constraints...
scaled = problem.fitpars;

unscaled = (scaled.*(limits(:,2)-limits(:,1)))+limits(:,1);

problem.fitpars = unscaled;

end