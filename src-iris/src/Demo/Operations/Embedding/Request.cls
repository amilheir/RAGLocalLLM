Class Demo.Operations.Embedding.Request Extends (%Persistent, Ens.Request)
{

Property Pdf As %Integer;

Property Chunks As %String(MAXLEN = "");

Storage Default
{
<Data name="RequestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Pdf</Value>
</Value>
<Value name="3">
<Value>Chunks</Value>
</Value>
</Data>
<DataLocation>^Demo.Operations.Em34B7.RequestD</DataLocation>
<DefaultData>RequestDefaultData</DefaultData>
<IdLocation>^Demo.Operations.Em34B7.RequestD</IdLocation>
<IndexLocation>^Demo.Operations.Em34B7.RequestI</IndexLocation>
<StreamLocation>^Demo.Operations.Em34B7.RequestS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
