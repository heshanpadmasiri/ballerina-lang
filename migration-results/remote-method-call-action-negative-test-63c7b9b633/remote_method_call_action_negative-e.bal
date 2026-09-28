public client class Client {
   public function init(string s, boolean b) {
   }

   remote function writeTextMessage(string s) {
   }
}

function caller() {
   // Since parser recovers remote method call action as the second parameter for new expression it will be invalid
   Client wsClient = new (wss://ws.finnhub.io/?token); // @error // @error
   checkpanic  wsClient->writeTextMessage("{\"type\":\"subscribe\",\"symbol\":\"AAPL\"}"); // @error // @error // @error // @error // @error
}
