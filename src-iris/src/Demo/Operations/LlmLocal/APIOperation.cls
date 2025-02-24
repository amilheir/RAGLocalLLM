Class Demo.Operations.LlmLocal.APIOperation Extends Ens.BusinessOperation
{

Parameter INVOCATION = "Queue";

/// These are the production settings for this object
/// /// Ollama models can be choose on https://Ollama.com/
Parameter SETTINGS = "Model:LLM Local,Host:LLM Local,Port:LLM Local,ChatBotInstructions:LLM Local, NumPredict:LLM Local,TopK:LLM Local,TopP:LLM Local,Temperature:LLM Local";

/// Model used in operation.
Property Model As %String(VALUELIST = ",smollm2:1.7b,llama3.2:1b,llama3.2:3b,gemma2:2b,gemma2:9b,qwen2.5:3b,qwen2.5:7b,mistral:7b,deepseek-r1:1.5b,deepseek-r1:7b");

Property Host As %String(MAXLEN = 256) [ InitialExpression = "host.docker.internal" ];

Property Port As %String(MAXLEN = 5) [ InitialExpression = "11434" ];

Property ChatBotInstructions As %String(MAXLEN = 256) [ InitialExpression = "You are a helpful assistant that answer questions based on a Context." ];

/// Maximum number of tokens to predict when generating text. (Default: -1, infinite generation)
Property NumPredict As %Integer [ InitialExpression = 200 ];

/// Reduces the probability of generating nonsense. A higher value (e.g. 100) will give more diverse answers, while a lower value (e.g. 10) will be more conservative. (Default: 40)
Property TopK As %Integer [ InitialExpression = 40 ];

/// Works together with top-k. A higher value (e.g., 0.95) will lead to more diverse text, while a lower value (e.g., 0.5) will generate more focused and conservative text. (Default: 0.9)
Property TopP As %Float [ InitialExpression = 0.9 ];

/// The temperature of the model. Increasing the temperature will make the model answer more creatively. (Default: 0.8)
Property Temperature As %Float [ InitialExpression = 0.8 ];

XData MessageMap
{
<MapItems>
  <MapItem MessageType="Demo.GenerateRequest">
    <Method>OnGenerateRequest</Method>
  </MapItem>
</MapItems>
}

Method OnGenerateRequest(pRequest As Demo.GenerateRequest, Output pResponse As Demo.GenerateResponse) As %Status
{
    #dim sc As %Status = $$$OK
    Set pResponse = ##class(Demo.GenerateResponse).%New()
    Try {
        Set pResponse.Model = ..Model
        Set pResponse.Response = ..GenerateRequest(pRequest)
    } Catch ex {
        Set sc = ex.AsStatus()
    }

    Quit sc
}

Method GenerateRequest(pRequest As Demo.GenerateRequest) As %String [ Language = python ]
{
    import requests
    import json

    url = "http://"+self.Host+":"+self.Port
    urlR =  url+"/api/tags"
    models =  requests.get(urlR)

    if self.Model not in models.text:
        urlR =  url+"/api/pull"
        request = {
                    "model": self.Model
                }
        status =  requests.post(urlR, json=request)
        self.Trace("Pull Response: " + str(status))

    urlR = url+"/api/chat"
    request = {
        "model": self.Model,
        "messages": [
            {"role": "assistant", "content": self.ChatBotInstructions},
            {"role": "user", "content": pRequest.Prompt}],
        "stream": False,
        "options": {
            "temperature": self.Temperature,
            "mirostat": 2, 
            "num_predict": self.NumPredict, 
            "top_k": self.TopK, 
            "top_p": self.TopP
        }
        } 

    self.Trace("API Request: " + str(request))
    response =  requests.post(urlR, json=request)
    
    self.Trace("API Response: " + response.text)
    responseObj = json.loads(response.text)

    output = responseObj['message']['content']
    return output
}

ClassMethod LogInfo(Msg As %String)
{
    $$$LOGINFO(Msg)
}

ClassMethod Trace(Msg As %String)
{
    $$$TRACE(Msg)
}

}
