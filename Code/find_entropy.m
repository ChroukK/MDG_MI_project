function H = find_entropy(prob_dist)
% We use the convention that 0*log2(0)= 0 which is justified by continuity 
    indNoZero = prob_dist ~= 0;
    prob_no_zero = prob_dist(indNoZero);
    H = -sum(prob_no_zero.*log2(prob_no_zero));
end