// Prepare the Tokens in the key and default set for evaluation:
// If the kind!=word, set the lemma in both to ""
// Set the lemma in the default set to lowercase otherwise

import gate.*;
import java.util.*;

private boolean DEBUG = true;

private int nDocs = 0;
private int nCorrect = 0;
private int nTotal = 0;
private int nWord = 0;
private int nOther = 0;
private int nWithOneResponse = 0;
private int nWithZeroResponse = 0;
private int nWithNResponse = 0;

private Map<String,Integer> correctByType = new TreeMap<String,Integer>();
private Map<String,Integer> totalByType = new TreeMap<String,Integer>();

@Override
public void execute() {
  nDocs += 1;
  AnnotationSet tokensResp = doc.getAnnotations().get("Token");
  AnnotationSet tokensKey = doc.getAnnotations("Key").get("Token");
  for(Annotation token : tokensKey) {
    nTotal += 1;
    FeatureMap fm = token.getFeatures();
    String kind = (String)fm.get("kind");
    
    ///////////////////////// ACTUAL EVALUATION CODE
    if(kind.equals("word")) {
      nWord += 1;
      AnnotationSet responses = gate.Utils.getOverlappingAnnotations(tokensResp,token);
      if(responses.size() == 1) {
        nWithOneResponse += 1;
        Annotation response = gate.Utils.getOnlyAnn(responses);
        FeatureMap fmResp = response.getFeatures();
        String targetLemma = (String)fm.get("lemma");
        String respLemma = (String)fmResp.get("lemma");
        String status = (String)fmResp.get("lemmatizer.status");
        if(status == null) {
          status = "(null)";
        }
        if(totalByType.containsKey(status)) {
          totalByType.put(status,totalByType.get(status)+1);
        } else {
          totalByType.put(status,1);
        }
        if(targetLemma == null) targetLemma = "";
        if(respLemma == null) {
          respLemma = "";
          System.err.println("No lemma for "+fmResp.get("string")+
          " pos="+fmResp.get("category")+" upos="+fmResp.get("upos"));
        }
        if(targetLemma.toLowerCase().equals(respLemma.toLowerCase())) {
          nCorrect += 1;
          if(correctByType.containsKey(status)) {
            correctByType.put(status,correctByType.get(status)+1);
          } else {
            correctByType.put(status,1);
          }
        } else {
          if(DEBUG) System.out.println("DEBUG\t"+status+"\t"+fmResp.get("upos")+"/"+fmResp.get("category")+"\t"+targetLemma+"\t"+respLemma);
        }
      } else if(responses.size() == 0) {
        nWithZeroResponse += 1;
      } else {
        nWithNResponse += 1;
      }
    } else {
      nOther += 1;
    }
  }
}

@Override
public void controllerStarted() {
  System.err.println("DEBUG: running controller started");
  nDocs = 0;
  nCorrect = 0;
  nTotal = 0;
  nWord = 0;
  nOther = 0;
  nWithOneResponse = 0;
  nWithZeroResponse = 0;
  nWithNResponse = 0;
  correctByType = new TreeMap<String,Integer>();
  totalByType = new TreeMap<String,Integer>();
}

@Override
public void controllerFinished() {
  System.err.println("DEBUG: running controller finished");
  System.out.println("Documents:    "+nDocs);
  System.out.println("Total Tokens: "+nTotal);
  System.out.println("Word Tokens:  "+nWord);
  System.out.println("Other Tokens: "+nOther);
  System.out.println("Word, 1 Resp: "+nWithOneResponse);
  System.out.println("Word, 0 Resp: "+nWithZeroResponse);
  System.out.println("Word, N Resp: "+nWithNResponse);
  System.out.println("Correct:      "+nCorrect);
  System.out.println("Recall/Acc:   "+(((double)nCorrect)/((double)nWithOneResponse)));
  System.out.println("Correct/Incorrect/Acc / %ofAll by status:");
  for(String key : correctByType.keySet()) {
    int correct = correctByType.get(key);
    int total   = totalByType.get(key);
    int incorrect = total - correct;
    System.out.println("  - "+key+": "+correct+" / "+incorrect+" / "+
    (((double)correct)/((double)total))+" / "+((double)total)/((double)nWithOneResponse));
  }
}
