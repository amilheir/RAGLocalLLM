Class Demo.DemoProduction Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="Demo.DemoProduction" TestingEnabled="true" LogGeneralTraceEvents="true">
  <Description></Description>
  <ActorPoolSize>1</ActorPoolSize>
  <Item Name="Embedding Operation" Category="" ClassName="Demo.Operations.Embedding.EmbeddingOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="ChunkOverlap">51</Setting>
    <Setting Target="Host" Name="ChunkSize">512</Setting>
    <Setting Target="Host" Name="FailureTimeout">-1</Setting>
  </Item>
  <Item Name="RAG Operation" Category="" ClassName="Demo.Operations.RAG.RAGOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="FailureTimeout">-1</Setting>
    <Setting Target="Host" Name="NumberOfRetrivals">5</Setting>
  </Item>
  <Item Name="Injection Process" Category="" ClassName="Demo.Processes.InjectionProcess" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="Prompt Operation" Category="" ClassName="Demo.Operations.Prompt.PromptOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="Streamlit Service" Category="" ClassName="Demo.Service.StreamlitService" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigName">LLM Process Local</Setting>
  </Item>
  <Item Name="Start Audio Import" Category="" ClassName="Demo.Service.CheckAudioFile" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="ArchivePath">/iris-shared/Archieve/</Setting>
    <Setting Target="Adapter" Name="FilePath">/iris-shared/Input/</Setting>
  </Item>
  <Item Name="LLM Operation" Category="" ClassName="Demo.Operations.LlmLocal.APIOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="Model">gemma3:4b</Setting>
    <Setting Target="Host" Name="ChatBotInstructions">You are a helpful assistant that answer questions. Your task is to answer the user's question using only the information provided in the context. If the context doesn't contain the answer, respond with "I can't answer this question based on the context provided." If the answer is present, summarize the relevant information into a clear and concise response. Don't add any information that isn't present in the context or say it is based on context.</Setting>
    <Setting Target="Host" Name="NumPredict">200</Setting>
    <Setting Target="Host" Name="TopK">40</Setting>
    <Setting Target="Host" Name="TopP">0.7</Setting>
    <Setting Target="Host" Name="Temperature">0.3</Setting>
    <Setting Target="Host" Name="Port">11437</Setting>
  </Item>
  <Item Name="LLM Process Local" Category="" ClassName="Demo.Processes.LLMProcessLocal" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
</Production>
}

}
