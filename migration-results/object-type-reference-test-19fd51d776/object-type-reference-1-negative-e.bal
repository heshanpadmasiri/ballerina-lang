// Copyright (c) 2018, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

type Person1 object {
    public int age;
    public string name;
};

type Employee1 object {
    public float salary;
};

class Manager1 {
    *Person1; // @error
    *Employee1; // @error

    string dpt = "HR";
}

type EmployeeWithSalary object {
    public float salary;
};

type AnotherEmployeeWithSalary object {
    public int salary;
};

class ManagerWithTwoSalaries {
    *Person1; // @error

    string dpt = "HR";
    *EmployeeWithSalary; // @error
}

// Test errors for unimplemented methods
type Person2 object {
    public int age;
    public string name;

    public function getName(string? title) returns string;
};

type Employee2 object {
    *Person2;
    public float salary;

    // Unimplemented function at the referenced type.
    public function getSalary() returns float;
};

class Manager2 {
    string dpt = "HR";
    *Employee2; // @error

    public function getName(string? title) returns string {
        return self.name; // @error
    }

    public function getSalary() returns float {
        return self.salary; // @error
    }
}
