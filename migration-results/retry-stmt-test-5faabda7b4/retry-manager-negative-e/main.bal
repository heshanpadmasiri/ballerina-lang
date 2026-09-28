class MyRetryManager {
   public function shouldRetry(error e) returns boolean {
      return true;
   }
}

function testRetryWithCustomRetryManager() {
    retry<MyRetryMgr> ("test") { // @error
        // do nothing
    }
}

function testRetryWithInvalidArgs() {
    retry<MyRetryManager> (value) { // @error
        // do nothing
    }
}
