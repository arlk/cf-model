function sigmaunderbar = sigmaUnder(a,delta)
	sigmaunderbar = nthroot(1/sum(a.^-delta),delta);
end

