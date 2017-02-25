// Prepare the Tokens in the key and default set for evaluation:
// If the kind!=word, set the lemma in both to ""
// Set the lemma in the default set to lowercase otherwise

import gate.*;
import java.util.*;

private boolean DEBUG = true;

private int nDocs = 0;
private int nCorrect = 0;
private int nTotal = 0;
//private int nWord = 0;
//private int nOther = 0;
private int nWithOneResponse = 0;
private int nWithZeroResponse = 0;
private int nWithNResponse = 0;
private int nWithOneCoextensive = 0;
private int nWithOneNonCoextensive = 0;
private int nTargetLemmaEmpty = 0;
private int nTargetLemmaFound = 0;
private int nMultiToken = 0;
private int nPosTotal = 0;
private int nPosCorrect = 0;

private Map<String,Integer> correctByType = new TreeMap<String,Integer>();
private Map<String,Integer> totalByType = new TreeMap<String,Integer>();
private Map<String,Integer> posMismatches = new TreeMap<String,Integer>();

@Override
public void execute() {
  nDocs += 1;
  AnnotationSet tokensResp = doc.getAnnotations().get("Token");
  AnnotationSet tokensKey = doc.getAnnotations("Key").get("Token");
  
  // go through the target/gold tokens
  for(Annotation token : tokensKey) {
    nTotal += 1;
    // check if the target token overlaps with another target token which
    // can happen for some corpora where we really have multi-token words
    AnnotationSet multiTargets = gate.Utils.getOverlappingAnnotations(tokensKey,token);
    // the result set contains the original token, so if there are overlapping ones 
    // we would at least get two
    if(multiTargets.size() > 1) {
      nMultiToken += 1;
      continue;
    }
    
    FeatureMap fm = token.getFeatures();
    // Most corpora use as the lemma of punctuation etc the original string.
    // However, some corpora do not include a target lemma for these, e.g.
    // the tiger corpus. Since we try to make a fair comparison we use the 
    // original string if the corpus is one of those where a lemma is not set
    // for punctuation (so far only tiger).
    // Currently we detect the corpus where we need to copy over the string to 
    // the target lemma if it is punctuation by checking for a pos tag that starts 
    // with $
    boolean copyLemma = false;
    String posKey = (String)fm.get("pos");
    if(posKey != null) {
      if(posKey.startsWith("$")) copyLemma = true;
    }

    ///////////////////////// ACTUAL EVALUATION CODE

    // this if is left over from when we only evaluated over words, but we 
    // now evaluate over all tokens
    //if(true) {
      //nWord += 1;
      // find our own tokens: since we generate them in GATE, we could find
      // situations where the GATE tokens do not properly match the target tokens.
      // However, some target corpora also support multi-token words .. these
      // situations already got filtered out earlier (see above).
      AnnotationSet responses = gate.Utils.getOverlappingAnnotations(tokensResp,token);      
      if(responses.size() == 1) {
        // if we get one overlapping response token, it may be coextensive 
        // or somehow otherwise overlapping. For the evaluation, we only use
        // exactly coextensive annotations
        nWithOneResponse += 1;
        AnnotationSet coextResponses = gate.Utils.getCoextensiveAnnotations(responses,token);
        if(coextResponses.size() == 1) {
          nWithOneCoextensive += 1;
          Annotation response = gate.Utils.getOnlyAnn(coextResponses);
          String targetLemma = (String)fm.get("lemma");
          if(targetLemma == null) targetLemma = "";
          if(targetLemma.equals("--")) targetLemma = "";
          // get the stats for the POS tags
          FeatureMap fmResp = response.getFeatures();
          String targetPOS = (String)fm.get("upos"); 
          String responsePOS = (String)fmResp.get("upos");
          if(targetPOS==null) targetPOS = "";
          if(responsePOS==null) responsePOS = "";
          nPosTotal += 1;
          if(targetPOS.equals(responsePOS)) {
            nPosCorrect += 1;
          } else {
            String entry = targetPOS + "/" + responsePOS;
            if(posMismatches.containsKey(entry)) {
              posMismatches.put(entry,posMismatches.get(entry)+1);
            } else {
              posMismatches.put(entry,1);
            }
          }
          if(targetLemma.isEmpty()) {
            nTargetLemmaEmpty += 1;
          } else {
            nTargetLemmaFound += 1;
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
          } // else of targetLemma is empty
        } else { // if one coext response
          // one response, but not coextensive
          nWithOneNonCoextensive += 1;
        }
      } else if(responses.size() == 0) {
        nWithZeroResponse += 1;
      } else {
        nWithNResponse += 1;
      }
    //} else {
    //  nOther += 1;
    //}
  }
}

@Override
public void controllerStarted() {
  System.err.println("DEBUG: running controller started");
  nDocs = 0;
  nCorrect = 0;
  nTotal = 0;
  //nWord = 0;
  //nOther = 0;
  nWithOneResponse = 0;
  nWithZeroResponse = 0;
  nWithNResponse = 0;
  nWithOneCoextensive = 0;
  nWithOneNonCoextensive = 0;
  nTargetLemmaEmpty = 0;
  nTargetLemmaFound = 0;
  nMultiToken = 0;
  nPosTotal = 0;
  nPosCorrect = 0;
  correctByType = new TreeMap<String,Integer>();
  totalByType = new TreeMap<String,Integer>();
  posMismatches = new TreeMap<String,Integer>();
}

@Override
public void controllerFinished() {
  System.err.println("DEBUG: running controller finished");
  System.out.println("Documents:              "+nDocs);
  System.out.println("Total target tokens:    "+nTotal);
  System.out.println("Multi-token words:      "+nMultiToken);
  //System.out.println("Target word tokens:     "+nWord);
  //System.out.println("Target other tokens:    "+nOther);
  System.out.println("Word token, w/ 0 Resp:  "+nWithZeroResponse);
  System.out.println("Word token, w/ N Resp:  "+nWithNResponse);
  System.out.println("Word token, w/ 1 Resp:  "+nWithOneResponse);
  System.out.println("- non coext:            "+nWithOneNonCoextensive);
  System.out.println("- coextensive:          "+nWithOneCoextensive);
  System.out.println("  - no lemma:           "+nTargetLemmaEmpty);
  System.out.println("  - has lemma:          "+nTargetLemmaFound);
  System.out.println("POS total:              "+nPosTotal);
  System.out.println("POS correct:            "+nPosCorrect);
  for(String key : posMismatches.keySet()) {
    System.out.println("  "+key+": "+posMismatches.get(key));
  }
  System.out.println("POS accuracy:           "+((double)nPosCorrect/(double)nPosTotal));
  System.out.println("Target word toekns with 1 Resp, coext, has lemma are the ones used for evaluation of which:");
  System.out.println("  Correct:      "+nCorrect);
  System.out.println("  Empty lemma:  "+nTargetLemmaEmpty);
  System.out.println("  Recall/Acc:   "+(((double)nCorrect)/((double)nWithOneResponse)));
  System.out.println("  Correct/Incorrect/Acc / %ofAll by status:");
  for(String key : correctByType.keySet()) {
    int correct = correctByType.get(key);
    int total   = totalByType.get(key);
    int incorrect = total - correct;
    System.out.println("    - "+key+": "+correct+" / "+incorrect+" / "+
    (((double)correct)/((double)total))+" / "+((double)total)/((double)nWithOneResponse));
  }
}
