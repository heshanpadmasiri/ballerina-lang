/*
 *  Copyright (c) 2024, WSO2 LLC. (http://www.wso2.com).
 *
 *  WSO2 LLC. licenses this file to you under the Apache License,
 *  Version 2.0 (the "License"); you may not use this file except
 *  in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing,
 *  software distributed under the License is distributed on an
 *  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 *  KIND, either express or implied. See the License for the
 *  specific language governing permissions and limitations
 *  under the License.
 */
package org.wso2.ballerinalang.compiler.tree.expressions;

import java.util.Objects;

import org.wso2.ballerinalang.compiler.semantics.model.SymbolEnv;
import org.wso2.ballerinalang.compiler.semantics.model.symbols.BSymbol;
import org.wso2.ballerinalang.compiler.semantics.model.types.BType;
import org.wso2.ballerinalang.compiler.tree.BLangIdentifier;

/**
 * Represents commons in worker async-send, sync-send and single-receive.
 *
 * @since 2201.9.0
 */
public abstract class BLangWorkerSendReceiveExpr extends BLangExpression {

    public SymbolEnv env;
    public BSymbol workerSymbol;
    public BType workerType;
    public BLangIdentifier workerIdentifier;
    private Channel channel;

    public Channel getChannel() {
        return channel;
    }

    public void setChannel(Channel channel) {
        this.channel = channel;
    }

    public static final class Channel {

        private final String sender;
        private final String receiver;
        private final int eventIndex;

        public Channel(String sender, String receiver, int eventIndex) {
            this.sender = sender;
            this.receiver = receiver;
            this.eventIndex = eventIndex;
        }

            public String workerPairId() {
                return workerPairId(sender, receiver);
            }

            public static String workerPairId(String sender, String receiver) {
                return sender + "->" + receiver;
            }

            public String channelId() {
                return sender + "->" + receiver + ":" + eventIndex;
            }

        public String sender() {
            return sender;
        }

        public String receiver() {
            return receiver;
        }

        public int eventIndex() {
            return eventIndex;
        }

        @Override
        public boolean equals(Object obj) {
            if (obj == this) return true;
            if (obj == null || obj.getClass() != this.getClass()) return false;
            var that = (Channel) obj;
            return Objects.equals(this.sender, that.sender) &&
                    Objects.equals(this.receiver, that.receiver) &&
                    this.eventIndex == that.eventIndex;
        }

        @Override
        public int hashCode() {
            return Objects.hash(sender, receiver, eventIndex);
        }

        @Override
        public String toString() {
            return "Channel[" +
                    "sender=" + sender + ", " +
                    "receiver=" + receiver + ", " +
                    "eventIndex=" + eventIndex + ']';
        }

        }
}
