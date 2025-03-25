This project is a recreation of the paper: https://ieeexplore.ieee.org/abstract/document/8272484
Objects:
	1.	scm() -> SCM3GPP
	2.	mmse() -> CondNormalMMSE
	3.	cntf() -> CondNormalTF
	4.	Channel() -> scm.SCMMulti
Functions:
	1.	get_channel
	2.	get_cov
	3.	get_circ_cov_generator
MMSE calculator:
	1.	Discrete MMSE functions:
		a.	mmse.DiscreteMMSE -> object est(rho, W, bias)  = f(snr, get_cov; nSamples = 1)
			i.	get_cov -> C = f(t) (function generated from function scm.toeplitzHe)
			1.	scm.toeplitzHe -> C = f(t)
				a.	scm.generate_channel -> (h, t) = f(SCMMulti Object, nAntennas; nCoherence = 1, nBatches = 1)
					i.	SCMMulti.scm_channel -> (h, t) = f (angles, weights, nAntennas; nCoherence = 1, AS = 2.0)
					1.	spectrum -> v =f(x_rad, angles, weights; AS = 2.0)
					a.	Laplace -> v = f(x_deg, angles, weights; AS = 2.0)
	2.	chan_from_spectrum -> (h, t) = f(function, nAntennas; nCoherence = 1)
