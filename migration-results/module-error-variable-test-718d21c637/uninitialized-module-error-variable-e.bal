type ErrorDetail record {
    int riskLevel;
};

type RiskError error<ErrorDetail>;

RiskError error RiskError(errorMsg, cause, riskLevel = riskLevel); // @error

function init() {
    errorMsg = "AssignmentFailed";
    cause = error("CCE");
    riskLevel = 5;
}

public function main() {
    string msg = errorMsg;
}
