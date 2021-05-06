# Prio with Differential Privacy

**DISCLAIMER: 
This code is not thoroughly tested or reviewed yet. DO NOT use it in production. Feedback and questions are very welcome.**

This package combines the secure aggregation and range proofs of
mozillas [libprio](https://github.com/mozilla/libprio) with the 
[discrete gaussian noise](https://github.com/google/differential-privacy/blob/73207653bb5a71df79e2bcf0711488c4a91b5cc2/cc/algorithms/distributions.h#L36) of googles differential-privacy library.

A short overview of the protocol:
- Clients secret share data 
- Clients compute range proofs and shares of them
- Clients submit data shares and proof shares to the servers 
- Using the proof shares, servers verify whether the submissions lie in a certain range
- If valid, each server sums the data shares
- Each server adds discrete gaussian noise to the sum of the data shares
- Both servers reconstruct the noised sum of the submissions

Servers never see plaintext submissions. The reconstructed sum contains noise, making the process differentially private.

Servers are assumed to be honest-but-curious, clients are assumed to be strategic/malicious.

This package will be used as a backend for "Federated Mechanism Learning with Strategic Agents" ([preprint on non-federated setting](https://arxiv.org/abs/2104.00159)).

The requirements for this use case are:
- No trust in the users should be necessary, especially regarding the correct execution of differential privacy
- There should not be a single point of failure

### Running an example
Clone this repository, install the [dependencies of libprio](https://github.com/mozilla/libprio#running-the-code) and [differential-privacy](https://github.com/google/differential-privacy/#how-to-build), then run:

``` 
make
./libprio/build/pclient_dp/pclient_dp
```

The example code is in: ``` ./libprio/pclient_dp/main.c ``` 

### Roadmap
- [ ] Implement C++/python bindings
  - [ ] Add stochastic tests
  - [ ] Attach privacy accountant
  - [ ] Integrate with ML Framework
  - [ ] Use as Federated Learning backend
- [ ] Implement headroom estimator for noise
- [ ] Randomize rounding for fixed-point encoding?

### Limitations
#### Fixed-point encoding
Since prio uses integers, we encode floats as fixed-point numbers in the [Qm.n format](https://en.wikipedia.org/wiki/Q_(number_format)), with m+n <= 21. This should be sufficient for federated learning.

#### Range Proofs
If range per entry of a vector is set to `-C <= x <= C` the maximum norm of an n-element vector can be up to `sqrt(n*C^2)`, which is not tight. A later port to [libprio-rs](https://github.com/abetterinternet/libprio-rs/), which implements a more flexible proof system, might alleviate this.
