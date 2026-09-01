import unknown/module; // @error

type R record {|
    module:foo a; // @error
|};

public function main() {
    R & readonly bar = 2; // @error
}
