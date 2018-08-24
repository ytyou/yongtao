package org.you.fttree;

import org.apache.commons.lang3.mutable.MutableInt;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.*;

public class FTTree {

    private static class Node {

        private WordFreq label;
        private Map<String,Node> kids;

        Node(WordFreq label) {
            this.label = label;
            this.kids = new HashMap<>();
        }

        public void addKid(Node kid) {
            kids.put(kid.label.getWord(), kid);
        }

        public Node findKid(String token) {
            return kids.get(token);
        }

        public void printClusters(List<Node> ancestors) {

            int cardinality = 0;

            if (this.isLeaf()) {
                cardinality = 1;
            }

            // TODO: This magic number needs to be in a config.
            if ((cardinality == 0) && (this.kids.size() > 5)) {
                boolean leaves = true;
                for (Node kid: this.kids.values()) {
                    if (! kid.isLeaf()) {
                        leaves = false;
                        break;
                    }
                }

                if (leaves) {
                    cardinality = this.kids.size();
                }
            }

            if (cardinality > 0) {
                System.out.print("["+cardinality+"]");
                for (Node a: ancestors) {
                    System.out.print(a.label.toString() + ", ");
                }
                System.out.println(this.label.toString());
                return;
            }

            ancestors.add(this);

            for (Node kid: this.kids.values()) {
                kid.printClusters(ancestors);
            }

            ancestors.remove(ancestors.size()-1);
        }

        private boolean isLeaf() {
            return this.kids.isEmpty();
        }

        @Override
        public String toString() {
            StringBuilder sb = new StringBuilder();
            sb.append("{");
            sb.append(label.toString());
            sb.append(",\"kids\":[");
            String comma = "";
            for (Node kid: this.kids.values()) {
                sb.append(comma);
                sb.append(kid.toString());
                comma = ",";
            }
            sb.append("]}");
            return sb.toString();
        }
    }

    private final static Logger logger = LoggerFactory.getLogger(FTTree.class);

    private Node root;
    private Map<String,MutableInt> words;

    public FTTree(Map<String,MutableInt> words) {
        this.words = words;
        root = new Node(new WordFreq("ROOT", 0));
    }

    public void build(Log log) {

        List<WordFreq> freqs = log.process(this.words);
        Node parent = this.root;

        for (WordFreq freq: freqs) {
            Node kid = parent.findKid(freq.getWord());
            if (kid == null) {
                kid = new Node(freq);
                parent.addKid(kid);
            }
            parent = kid;
        }
    }

    public void printClusters() {
        List<Node> ancestors = new LinkedList<>();
        this.root.printClusters(ancestors);
    }

    @Override
    public String toString() {
        return this.root.toString();
    }
}
