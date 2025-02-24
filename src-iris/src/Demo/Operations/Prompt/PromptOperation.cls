Class Demo.Operations.Prompt.PromptOperation Extends Ens.BusinessOperation
{

Method OnPrompt(pRequest As Demo.Operations.Prompt.PromptRequest, pResponse As Demo.Operations.Prompt.PromptResponse) As %Status
{
    Set tSc = $$$OK
    Try {
      Set tDoclist = $LISTFROMSTRING(pRequest.DocIds,",")
      Set pResponse = ##class(Demo.Operations.Prompt.PromptResponse).%New()
      Set tContextString = "Context:"
      For i=2:1:$LISTLENGTH(tDoclist) {
          Set tDoc = ##class(Demo.RecordEmbeddings).%OpenId($LIST(tDoclist, i))
          Set tContextString = tContextString _ " " _ tDoc.Text
      }
      Set tPromptString = "Prompt: " _ pRequest.Prompt
      Set tPrompt = tContextString _ " " _ tPromptString
      Set pResponse.Prompt = tPrompt
    } Catch tEx {
        Set tSc = tEx.AsStatus()
    }
    Return tSc
}

XData MessageMap
{
<MapItems>
  <MapItem MessageType="Demo.Operations.Prompt.PromptRequest">
    <Method>OnPrompt</Method>
  </MapItem>
</MapItems>
}

}
