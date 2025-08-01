Class Demo.Operations.LlmLocal.APIOperation Extends Ens.BusinessOperation
{

Parameter INVOCATION = "Queue";

/// These are the production settings for this object
/// /// Ollama models can be choose on https://Ollama.com/
Parameter SETTINGS = "Model:LLM Local,Host:LLM Local,Port:LLM Local,ChatBotInstructions:LLM Local, NumPredict:LLM Local,TopK:LLM Local,TopP:LLM Local,Temperature:LLM Local";

/// Model used in operation.
Property Model As %String(VALUELIST = ",smollm2:1.7b,llama3.2:3b,llama3:8b,gemma3:4b,gemma3:12b,qwen2.5:3b,qwen2.5:7b,mistral:7b");

Property Host As %String(MAXLEN = 256) [ InitialExpression = "host.docker.internal" ];

Property Port As %String(MAXLEN = 5) [ InitialExpression = "11434" ];

Property ChatBotInstructions As %String(MAXLEN = 1024) [ InitialExpression = "Your task is to answer the user's question using only the information provided in the context. If the context doesn't contain the answer, respond with ""I can't answer this question based on the context provided."" If the answer is present, summarize the relevant information into a clear and concise response. Don't add any information that isn't present in the context or say it is based on context." ];
/// ChatBotInstructions PTBR: Sua tarefa é responder à pergunta do usuário usando apenas as informações fornecidas no contexto. Se o contexto não contiver a resposta, responda com "Não posso responder a esta pergunta com base no contexto fornecido". Se a resposta estiver presente, sintetize as informações relevantes em uma resposta clara e concisa. Não adicione nenhuma informação que não esteja presente no contexto.
/// Maximum number of tokens to predict when generating text. (Default: -1, infinite generation)
Property NumPredict As %Integer [ InitialExpression = 200 ];

/// Reduces the probability of generating nonsense. A higher value (e.g. 100) will give more diverse answers, while a lower value (e.g. 10) will be more conservative. (Default: 40)
Property TopK As %Integer [ InitialExpression = 40 ];

/// Works together with top-k. A higher value (e.g., 0.95) will lead to more diverse text, while a lower value (e.g., 0.5) will generate more focused and conservative text. (Default: 0.9)
Property TopP As %Double [ InitialExpression = 0.7 ];

/// The temperature of the model. Increasing the temperature will make the model answer more creatively. (Default: 0.8)
Property Temperature As %Double [ InitialExpression = 0.3 ];

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
