{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy27
, packaging
, pytest
, cython
, numpy
, scipy
, h5py
, nibabel
}:

buildPythonPackage rec {
  pname = "dipy";
  version = "1.2.0";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner  = "dipy";
    repo   = pname;
    rev    = version;
    sha256 = "0x49lph400ndlvk419nd2g9ss4jg75xr7xh88ggv5d2ama19v7py";
  };

  nativeBuildInputs = [ cython packaging ];
  propagatedBuildInputs = [
    numpy
    scipy
    h5py
    nibabel
  ];

  checkInputs = [ pytest ];

  # disable tests for now due to:
  #   - some tests require data download (see dipy/dipy/issues/2092);
  #   - running the tests manually causes a multiprocessing hang;
  #   - import weirdness when running the tests
  doCheck = false;

  pythonImportsCheck = [
    "dipy"
    "dipy.core"
    "dipy.direction"
    "dipy.tracking"
    "dipy.reconst"
    "dipy.io"
    "dipy.viz"
    "dipy.boots"
    "dipy.data"
    "dipy.utils"
    "dipy.segment"
    "dipy.sims"
    "dipy.stats"
    "dipy.denoise"
    "dipy.workflows"
    "dipy.nn"
  ];

  meta = with lib; {
    homepage = "https://dipy.org/";
    description = "Diffusion imaging toolkit for Python";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
