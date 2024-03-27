/*
 *  Copyright (c) 2024, WSO2 LLC. (http://www.wso2.org).
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
 *  KIND, either express or implied.  See the License for the
 *  specific language governing permissions and limitations
 *  under the License.
 *
 *
 */

package io.ballerina.runtime.internal.types.semtype;

final class BddUtils {

    static BddNode bddAtom(Atom atom) {
        return new BddNode(atom, BddLeafNode.TRUE, BddLeafNode.FALSE, BddLeafNode.FALSE);
    }

    static SubTypeData bddSubtypeUnion(SubTypeData t1, SubTypeData t2) {
        if (t1 instanceof BddNode b1 && t2 instanceof BddNode b2) {
            return bddUnion(b1, b2);
        }
        throw new UnsupportedOperationException("bddSubtypeUnion not supported for non-BddNode types");
    }

    static SubTypeData bddSubtypeIntersect(SubTypeData t1, SubTypeData t2) {
        if (t1 instanceof BddNode b1 && t2 instanceof BddNode b2) {
            return bddIntersect(b1, b2);
        }
        throw new UnsupportedOperationException("bddSubtypeIntersect not supported for non-BddNode types");
    }

    static SubTypeData bddSubtypeDiff(SubTypeData t1, SubTypeData t2) {
        if (t1 instanceof BddNode b1 && t2 instanceof BddNode b2) {
            return bddDiff(b1, b2);
        }
        throw new UnsupportedOperationException("bddSubtypeDiff not supported for non-BddNode types");
    }

    static SubTypeData bddSubtypeComplement(SubTypeData t) {
        if (t instanceof BddNode bddNode) {
            return bddCompliment(bddNode);
        }
        throw new UnsupportedOperationException("bddSubtypeComplement not supported for non-BddNode types");
    }

    private static Bdd bddCreate(Atom atom, Bdd left, Bdd middle, Bdd right) {
        if (middle == BddLeafNode.TRUE) {
            return BddLeafNode.TRUE;
        }
        if (left == right) {
            return bddUnion(left, middle);
        }
        return new BddNode(atom, left, middle, right);
    }

    private static Bdd bddUnion(Bdd b1, Bdd b2) {
        if (b1 == b2) {
            return b1;
        } else if (b1 instanceof BddLeafNode b1Leaf) {
            return b1Leaf == BddLeafNode.TRUE ? BddLeafNode.TRUE : b2;
        } else if (b2 instanceof BddLeafNode b2Leaf) {
            return b2Leaf == BddLeafNode.TRUE ? BddLeafNode.TRUE : b1;
        }
        BddNode b1Node = (BddNode) b1;
        BddNode b2Node = (BddNode) b2;
        int cmp = atomCmp(b1Node.atom(), b2Node.atom());
        if (cmp < 0) {
            return bddCreate(b1Node.atom(),
                    b1Node.left(),
                    bddUnion(b1Node.middle(), b2),
                    b1Node.right());
        } else if (cmp > 0) {
            return bddCreate(b2Node.atom(),
                    b2Node.left(),
                    bddUnion(b1, b2Node.middle()),
                    b2Node.right());
        } else {
            return bddCreate(b1Node.atom(),
                    bddUnion(b1Node.left(), b2Node.left()),
                    bddUnion(b1Node.middle(), b2Node.middle()),
                    bddUnion(b1Node.right(), b2Node.right()));
        }
    }

    private static Bdd bddIntersect(Bdd b1, Bdd b2) {
        if (b1 == b2) {
            return b1;
        } else if (b1 instanceof BddLeafNode b1Leaf) {
            return b1Leaf == BddLeafNode.TRUE ? b2 : BddLeafNode.FALSE;
        } else if (b2 instanceof BddLeafNode b2Leaf) {
            return b2Leaf == BddLeafNode.TRUE ? b1 : BddLeafNode.FALSE;
        }
        BddNode b1Node = (BddNode) b1;
        BddNode b2Node = (BddNode) b2;
        int cmp = atomCmp(b1Node.atom(), b2Node.atom());
        if (cmp < 0) {
            return bddCreate(b1Node.atom(),
                    bddIntersect(b1Node.left(), b2),
                    bddIntersect(b1Node.middle(), b2),
                    bddIntersect(b1Node.right(), b2));
        } else if (cmp > 0) {
            return bddCreate(b2Node.atom(),
                    bddIntersect(b1, b2Node.left()),
                    bddIntersect(b1, b2Node.middle()),
                    bddIntersect(b1, b2Node.right()));
        } else {
            return bddCreate(b1Node.atom(),
                    bddIntersect(bddUnion(b1Node.left(), b1Node.middle()), bddUnion(b2Node.left(), b2Node.middle())),
                    BddLeafNode.FALSE,
                    bddIntersect(bddUnion(b1Node.right(), b1Node.middle()), bddUnion(b2Node.right(), b2Node.middle())));
        }
    }

    private static Bdd bddDiff(Bdd b1, Bdd b2) {
        if (b1 == b2) {
            return BddLeafNode.FALSE;
        } else if (b2 instanceof BddLeafNode b2Leaf) {
            return b2Leaf == BddLeafNode.TRUE ? BddLeafNode.FALSE : b1;
        } else if (b1 instanceof BddLeafNode b1Leaf) {
            return b1Leaf == BddLeafNode.TRUE ? bddCompliment(b2) : BddLeafNode.FALSE;
        }
        BddNode b1Node = (BddNode) b1;
        BddNode b2Node = (BddNode) b2;
        int cmp = atomCmp(b1Node.atom(), b2Node.atom());
        if (cmp < 0) {
            return bddCreate(b1Node.atom(),
                    bddDiff(bddUnion(b1Node.left(), b1Node.middle()), b2),
                    BddLeafNode.FALSE,
                    bddDiff(bddUnion(b1Node.right(), b1Node.middle()), b2));
        } else if (cmp > 0) {
            return bddCreate(b2Node.atom(),
                    bddDiff(b1, bddUnion(b2Node.left(), b2Node.middle())),
                    BddLeafNode.FALSE,
                    bddDiff(b1, bddUnion(b2Node.right(), b2Node.middle())));
        } else {
            return bddCreate(b1Node.atom(),
                    bddDiff(bddUnion(b1Node.left(), b1Node.middle()), bddUnion(b2Node.left(), b2Node.middle())),
                    BddLeafNode.FALSE,
                    bddDiff(bddUnion(b1Node.right(), b1Node.middle()), bddUnion(b2Node.right(), b2Node.middle())));
        }
    }

    private static Bdd bddCompliment(Bdd bdd) {
        if (bdd instanceof BddLeafNode bLeaf) {
            return bLeaf == BddLeafNode.TRUE ? BddLeafNode.FALSE : BddLeafNode.TRUE;
        }
        BddNode bNode = (BddNode) bdd;
        return bddNodeComplement(bNode);
    }

    private static Bdd bddNodeComplement(BddNode bddNode) {
        if (bddNode.right() == BddLeafNode.FALSE) {
            return bddCreate(bddNode.atom(),
                    BddLeafNode.FALSE,
                    bddCompliment(bddUnion(bddNode.left(), bddNode.middle())),
                    bddCompliment(bddNode.middle()));
        } else if (bddNode.left() == BddLeafNode.FALSE) {
            return bddCreate(bddNode.atom(),
                    bddCompliment(bddNode.middle()),
                    bddCompliment(bddUnion(bddNode.right(), bddNode.middle())),
                    BddLeafNode.FALSE);
        } else if (bddNode.middle() == BddLeafNode.FALSE) {
            return bddCreate(bddNode.atom(),
                    bddCompliment(bddNode.left()),
                    bddCompliment(bddUnion(bddNode.left(), bddNode.right())),
                    bddCompliment(bddNode.right()));
        } else {
            return bddCreate(bddNode.atom(),
                    bddCompliment(bddUnion(bddNode.left(), bddNode.middle())),
                    BddLeafNode.FALSE,
                    bddCompliment(bddUnion(bddNode.right(), bddNode.middle())));
        }
    }

    // order RecAtom < TypeAtom
    private static int atomCmp(Atom a1, Atom a2) {
        if (a1 instanceof RecAtom) {
            if (a2 instanceof RecAtom) {
                return a1.index() - a2.index();
            }
            return -1;
        } else if (a2 instanceof RecAtom) {
            return 1;
        }
        return a1.index() - a2.index();
    }

    private BddUtils() {
    }
}
