\name{ATE}
\alias{ATE}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Estimate the Average Treatment Effect
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
The main function for estimating the average treatment effect or the average treatment effect on the treated. This function creates an \code{ATE} object which can be used as inputs for generic S3 \code{plot} or \code{summary} functions. This function uses a covariate balancing method which creates weights for each subject, without a need to specific a propensity score or an outcome regression model. The main function depends on a Newton-Raphson algorithm with backtracking. For details of the estimator see Chan et al. (2015).
}
\usage{
ATE (Y, Ti, X, theta = 0, ATT = FALSE, 
    verbose = FALSE, max.iter = 100, tol = 1e-10, 
    initial.values = NULL, 
    backtrack = TRUE, backtrack.alpha = 0.3,
    backtrack.beta = 0.5, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{

  \item{Y}{
The response vector of length \eqn{n}. This has to be a numeric vector.
}

 \item{Ti}{
The vector of treatment assignments of length \eqn{n}. Must be coded as \eqn{\{0,1,\ldots} {{0,1,...}} and must be binary vector when \code{ATT=TRUE}.
}
 
 \item{X}{
A \eqn{n\times p}{n x p}-matrix of covariates \code{X} to be matched. This matrix does not need to include an intercept.
}

  \item{theta}{
A real scalar parameter for the Cressie-Read family of objective functions.  The default is \eqn{\theta=0} (exponential tilting).  Other popular examples are \eqn{\theta=-1} (exponential tilting) and \eqn{\theta=1} (quadratic loss).
}

  \item{ATT}{
A logical value indicating whether to estimate the treatment effect on the treated.
}
  \item{verbose}{
A logical value indicating whether to print the progress of the function. \code{FALSE} by default.
}
  \item{max.iter}{
The maximum number of iterations for the Newton-Raphson methods. For most problems (e.g. with well-behaved functions \eqn{\rho} and \eqn{u}) convergence of Newton-Raphson should be fairly quick.
}
  \item{tol}{
The absolute tolerance used to determine a stopping criteria for the Newton-Raphson algorithm.
}
  \item{initial.values}{
A numeric vector or matrix of possible initial values for the Newton-Raphson algorithm. Must be a \eqn{J\times K}{J x K} matrix where \eqn{J}{J} is the number of treatment arms. For \code{ATT = TRUE} this must be a \eqn{K}{K}-vector.
}
  \item{backtrack}{
A logical value indicating whether to use backtracking in the Newton-Raphson algorithm.  
}
  \item{backtrack.alpha}{
A scalar parameter for backtracking with \eqn{\alpha \in (0,0.5)}{\alpha in (0,0.5)}.
}
  \item{backtrack.beta}{
A scalar parameter for backtracking with \eqn{\beta \in (0,1)}{\beta in (0,1)}.
}

  \item{...}{
  Additional arguments.
  }

}


\value{
%%  ~Describe the value returned
The function reruns an object of type "ATE", a list with the following elements

\item{est}{
The vector of point estimates for the average treatment effect. For a binary treatment it also contains the average difference of treatment effects. 
}
\item{vcov}{
The estimated variance covariance matrix for the estimates of the treatment effects for each treatment group.
}
\item{lam}{
The resulting solution of the main optimization problems, \eqn{\hat{\lambda}}{hat{\lambda}}, as described in Chan et al.(2015). In the case of a simple, binary treatment study, the object has \code{lam.p} and \code{lam.q} and when \code{ATT = TRUE}, we only have \code{lam.q}. For a multiple treatment study design we have \code{lam.mat}, a matrix with each \eqn{\hat{\lambda}}{hat{\lambda}} corresponding to each treatment arm.
}
\item{weights}{
The weights obtained by the balancing covariate method for each treatment group. In the case of \code{ATT = TRUE}, we only have weights for the untreated. For binary treatment the list would contain either \code{weights.q} or \code{weights.p} or both. For multiple treatment effect the list contains a \eqn{J\times n} matrix \code{weights.mat}.
}
\item{gp}{
A string specifying the type of study design. For binary treatment effect with \code{ATT = FALSE} is denoted by group "simple". With \code{ATT = TRUE} we have "ATT" and finally "MT" is for multiple treatment arms.
}
\item{conv}{
A logical value indicating convergence of Newton-Raphson algorithm.
}
\item{X,Y, Ti}{
The data which was used for estimation.
}

\item{rho, rho1, rho2}{
The Cressie-Read functions \eqn{\rho} used for estimation along with the first and second derivatives. 
}
\item{FUNu}{
A function that append a vector of constants to the covariates.  Required to make sure that the weights sum to 1 in each group.
}
\item{J}{
A scalar indicating the number of treatment arms.
}
\item{K}{
A scalar indicating the one plus the dimension of the range space of X.
}
\item{call}{
The matched call.
}

}

\references{
Chan, K. C. G. and Yam, S. C. P. and Zhang, Z. (2015). "Globally Efficient Nonparametric Inference of Average Treatment Effects by Empirical Balancing Calibration Weighting", under revision.

Haris, Asad and Chan, K. C. G. (2015). "\pkg{ATE}: An \code{R} package for Nonparametric Inference of Average Treatment Effects ", under revision
}

\author{
Asad Haris, Gary Chan.
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
\code{\link{summary.ATE}},
\code{\link{plot.ATE}}
}
\examples{
library(ATE)
#binary treatment

set.seed(25)
n <- 200
Z <- matrix(rnorm(4*n),ncol=4,nrow=n)
prop <- 1 / (1 + exp(Z[,1] - 0.5 * Z[,2] + 0.25*Z[,3] + 0.1 * Z[,4]))
treat <- rbinom(n, 1, prop)
Y <- 200 + 10*treat+ (1.5*treat-0.5)*(27.4*Z[,1] + 13.7*Z[,2] +
          13.7*Z[,3] + 13.7*Z[,4]) + rnorm(n)
X <- cbind(exp(Z[,1])/2,Z[,2]/(1+exp(Z[,1])),
          (Z[,1]*Z[,3]/25+0.6)^3,(Z[,2]+Z[,4]+20)^2)

#estimation of average treatment effects (ATE)
fit1<-ATE(Y,treat,X)
summary(fit1)
#plot(fit1)

#estimation of average treatment effects on treated (ATT)
fit2<-ATE(Y,treat,X,ATT=TRUE)
summary(fit2)
#plot(fit2)


#three treatment groups
set.seed(25)
n <- 200
Z <- matrix(rnorm(4*n),ncol=4,nrow=n)
prop1 <- 1 / (1 + exp(1+Z[,1] - 0.5 * Z[,2] + 0.25*Z[,3] + 0.1 * Z[,4]))
prop2 <- 1 / (1 + exp(Z[,1] - 0.5 * Z[,2] + 0.25*Z[,3] + 0.1 * Z[,4]))

U <-runif(n)
treat <- numeric(n)
treat[U>(1-prop2)]=2
treat[U<(1-prop2)& U>(prop2-prop1)]=1

Y <- 210 + 10*treat +(27.4*Z[,1] + 13.7*Z[,2] + 
            13.7*Z[,3] + 13.7*Z[,4]) + rnorm(n)
X <- cbind(exp(Z[,1])/2,Z[,2]/(1+exp(Z[,1])),
            (Z[,1]*Z[,3]/25+0.6)^3,(Z[,2]+Z[,4]+20)^2)

fit3<-ATE(Y,treat,X)
summary(fit3)
#plot(fit3)

}
