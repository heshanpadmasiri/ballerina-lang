/*
 * Copyright (c) 2021, WSO2 Inc. (http://wso2.com) All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package io.ballerina.projects.plugins.codeaction;

/**
 * A command argument for the code action. Will be supplied to the code action when it's being executed.
 *
 * @since 2.0.0
 */
public class CodeActionArgument {

    private CodeActionArgument(String argumentK, Object value) {
        throw new RuntimeException();
    }

    public static CodeActionArgument from(String argumentK, Object argumentV) {
        throw new RuntimeException();
    }

    public static CodeActionArgument from(Object jsonObj) {
        throw new RuntimeException();
    }

    public String key() {
        throw new RuntimeException();
    }

    public <T> T value() {
        throw new RuntimeException();
    }

    public <T> T valueAs(Class<T> typeClass) {
        throw new RuntimeException();
    }
}
