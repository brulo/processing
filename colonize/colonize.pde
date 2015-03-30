// uses depricated google images search API to get urls of images for a seach term.
// 4 urls are returned per request.

// by illuminati, for ants, march 2015

import http.requests.*;

// editable params
String search_term = "ants";
int startOffset = 0;  // increase this to make results less related
int numResults = 40;  // should be in multiples of 4
ß
// not editable
int startIndex;
boolean gotImages = false;
ArrayList<PImage> images = new ArrayList<PImage>();
ArrayList<String> image_urls = new ArrayList<String>();

void setup() {
  startIndex = 0 + startOffset;
  numResults += startOffset;
  noLoop(); 
  size(700, 700);
}

void draw() {
  if (!gotImages) {
    while (startIndex < numResults) {
      String request;
      request = "http://ajax.googleapis.com/ajax/services/search/images?v=1.0&q=";
      request += search_term + "&start=" + startIndex;
      GetRequest get = new GetRequest(request);
      get.send();

      String[] jsonFileData = { 
        get.getContent(), ""
      };

      // write json to file because you cant parse json as a string...
      String fileName = "ants.txt";
      saveStrings(fileName, jsonFileData);

      JSONObject response = loadJSONObject(fileName);

      JSONObject responseData = response.getJSONObject("responseData");
      JSONArray results = responseData.getJSONArray("results");
      for (int i = 0; i < 4; i++) {
        JSONObject result = results.getJSONObject(i);
        image_urls.add(result.getString("url"));
      }
      startIndex += 4;
      delay(1000);
    }

    for (int i = 0; i < image_urls.size (); i++) {
      PImage image = null;
      try {
        image = loadImage(image_urls.get(i));
      }
      catch(Exception e) {
        println("couldn't load" + image_urls.get(i));
        image = null;
      }
      if(image != null) {
        //image.resize(100, 1);
        images.add(image);
      }
    }
    
    gotImages = true;
  }
  
  if (gotImages) {
    for (int i = 0; i < images.size (); i++) {
      println(i);
      image(images.get(i), random(0, displayWidth/2), random(0, displayHeight/2));
    }
  }
}

