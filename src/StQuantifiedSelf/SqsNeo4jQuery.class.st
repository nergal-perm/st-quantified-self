Class {
	#name : #SqsNeo4jQuery,
	#superclass : #Object,
	#instVars : [
		'response',
		'statement',
		'parameters'
	],
	#category : #'StQuantifiedSelf-Neo4j'
}

{ #category : #'instance creation' }
SqsNeo4jQuery class >> forDay: aDate [
	^ self new
		statement: 'match (d:Day {name: $name})<-[r]-(n) return n, r, d';
		parameters: (Dictionary newFromPairs: {#name . aDate yyyymmdd});
		yourself.
]

{ #category : #accessing }
SqsNeo4jQuery class >> forNovember13 [
	<gtExample>
	^ self forDay: (Date fromString: '11/13/2024')
]

{ #category : #actions }
SqsNeo4jQuery >> asRequestBody [
	^ STONJSON
		toString: (Dictionary
				newFromPairs: {#statement.
						self statement.
						#parameters.
						self parameters})
]

{ #category : #constants }
SqsNeo4jQuery >> databaseUrl [
	^ 'http://localhost:7474/db/quantified-self/query/v2'
]

{ #category : #views }
SqsNeo4jQuery >> gtResponseItemsFor: aView [
	<gtView>
	| view |
	self perform.
	view := aView columnedList
			title: 'Items';
			priority: 20;
			items: [ self relationships ];
			yourself.
	((self response at: #data) at: #fields)
		doWithIndex: [ :each :index | view column: each text: [ :item | SqsNeo4jEntity from: (item at: index) ] ].
	^ view
]

{ #category : #testing }
SqsNeo4jQuery >> hasRows [
	self perform.
	^ self relationships isNotEmpty
]

{ #category : #accessing }
SqsNeo4jQuery >> parameters [
	^ parameters
]

{ #category : #accessing }
SqsNeo4jQuery >> parameters: aDictionary [ 
	parameters := aDictionary
]

{ #category : #actions }
SqsNeo4jQuery >> perform [
	self response
		ifNil: [ response := STONJSON
					fromString: (ZnClient new
							url: self databaseUrl;
							entity: (ZnEntity json: self asRequestBody);
							post) ]
]

{ #category : #views }
SqsNeo4jQuery >> relationships [
	self perform.
	^ (self response at: #data) at: #values
]

{ #category : #accessing }
SqsNeo4jQuery >> response [
	^ response
]

{ #category : #accessing }
SqsNeo4jQuery >> response: anObject [
	response := anObject
]

{ #category : #accessing }
SqsNeo4jQuery >> statement [
	^ statement
]

{ #category : #accessing }
SqsNeo4jQuery >> statement: aString [ 
	statement := aString
]
