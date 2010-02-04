// Test the standard module Norm

use driver;
use Random;
use Norm;

config const is2D2Norm = false;

var rng = new RandomStream(314159265);

rng.fillRandom(R1D);
rng.fillRandom(R2D);
rng.fillRandom(R2D64);

var saved: [1..3][normType.norm1..normType.normFrob] int;

def iNorm(val, sigfigs=10) {
  return (val*(10**sigfigs):val.type):int;
}

def doNorm(A, loc, save=false) {
  if save then {
    var val = norm(A,normType.norm1);
    saved[loc][normType.norm1] = iNorm(val);
    writeln("\t1-norm: ", val);
  }
  else if iNorm(norm(A,normType.norm1)) != saved[loc][normType.norm1] then
    writeln("\t1-norm INCORRECT");
  else
    writeln("\t1-norm OK");

  if !is2D2Norm then
    if A.rank > 1 then
      writeln("\t2-Norm not yet implemented for rank=", A.rank);
  else {
    if save {
      var val = norm(A,normType.norm2);
      saved[loc][normType.norm2] = iNorm(val);
      writeln("\t2-norm: ", val);
    }
    else if iNorm(norm(A,normType.norm2)) != saved[loc][normType.norm2] then
      writeln("\t2-norm INCORRECT");
    else
      writeln("\t2-norm OK");
  }

  if save {
    var val = norm(A,normType.normInf);
    saved[loc][normType.normInf] = iNorm(val);
    writeln("\tinfinity norm: ", val);
  }
  else if iNorm(norm(A,normType.normInf)) != saved[loc][normType.normInf] then
    writeln("\tinfinity norm INCORRECT");
  else
    writeln("\tinfinity norm OK");

  if save {
    var val = norm(A,normType.normFrob);
    saved[loc][normType.normFrob] = iNorm(val);
    writeln("\tfrobenius norm: ", val);
  }
  else if iNorm(norm(A,normType.normFrob)) != saved[loc][normType.normFrob] then
    writeln("\tfrobenius norm INCORRECT");
  else
    writeln("\tfrobenius norm OK");
}

writeln("Vector norm (baseline)");
writeln("\tR1D:");
doNorm(R1D, 1, true);
writeln("\tR2D:");
doNorm(R2D, 2, true);
writeln("\tR2D64:");
doNorm(R2D64, 3, true);


writeln("Vector norm");
writeln("\tR1D:");
doNorm(R1D, 1);
writeln("\tR2D:");
doNorm(R2D, 2);
writeln("\tR2D64:");
doNorm(R2D64, 3);


writeln("Vector norm aliased arrays");
var aR1D => R1D;
var aR2D => R2D;
var aR2D64 => R2D64;
writeln("\tR1D:");
doNorm(aR1D, 1);
writeln("\tR2D:");
doNorm(aR2D, 2);
writeln("\tR2D64:");
doNorm(aR2D64, 3);


writeln("Vector norm reindexed arrays");
def foo(D: domain, A: [D], loc) {
  doNorm(A, loc);
}
const TD1D: domain(1) = Space1 - (o5);
const TD2D: domain(2) = Space2 - (o5,o5);
const TD2D64: domain(2,int(64)) = Space2D64 - (o5:int(64),o5:int(64));
writeln("\tR1D:");
foo(TD1D, R1D, 1);
writeln("\tR2D:");
foo(TD2D, R2D, 2);
writeln("\tR2D64:");
foo(TD2D64, R2D64, 2);


writeln("Vector norm rank changed arrays (baseline)");
var rcT1D => R2D(Dom2D.dim(1), n2-o5);
var rcT2D => R3D(Dom3D.dim(1), Dom3D.dim(2), n2-o5);
const rcDom1D: domain(1) distributed Dist1D = Dom2D.dim(1);
const rcDom2D: domain(2) distributed Dist2D = [Dom3D.dim(1), Dom3D.dim(2)];
var rcR1D: [rcDom1D] real;
var rcR2D: [rcDom2D] real;
rng.fillRandom(rcR1D);
rng.fillRandom(rcR2D);
rcT1D = rcR1D;
rcT2D = rcR2D;
writeln("\trcR1D:");
doNorm(rcR1D, 1, true);
writeln("\trcR2D:");
doNorm(rcR2D, 2, true);


writeln("Vector norm rank changed arrays");
writeln("\trcR1D:");
doNorm(rcR1D, 1);
writeln("\trcR2D:");
doNorm(rcR2D, 2);
