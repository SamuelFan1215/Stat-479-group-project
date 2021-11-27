data {
  int K; // K = 1
  int D; // number of predictors
  int<lower = 0> N; // number of observed data
  int<lower = 0, upper = 1> y[N]; // response variable
  matrix[N, D] x; // matrix of predictors
  int n_grid; // number of points in the grid of x values at which we want to evaluate P(y = 1|x)
  vector[n_grid] deltaOEFF_grid; // two grids for generated quantities, length = 181
  vector[n_grid] deltaDEFF_grid; 
}
parameters {
  matrix[D, K] beta; // coefficient matrix
}
model {
  matrix[N, K] x_beta = x * beta;

  to_vector(beta)[1] ~ normal(0.92, 0.05); // prior for beta_1, not specified
  to_vector(beta)[2] ~ normal(-0.03, 0.05); // prior for beta_2
    for(n in 1:N) {
    y[n] ~ bernoulli_logit(x_beta[n]'); // use inverse matrix
  }
}

generated quantities{
  vector<lower = 0, upper = 1>[n_grid] prob_grid; // predictive probabilities grid
  for(i in 1:n_grid){
    prob_grid[i] = inv_logit(deltaOEFF_grid[i] * to_vector(beta)[1] + deltaDEFF_grid[i] * to_vector(beta)[2]); // posterior predivtive probabilities
  }
}




