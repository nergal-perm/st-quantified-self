Class {
	#name : #SqsNeo4jDayWithLinksQuery,
	#superclass : #Object,
	#instVars : [
		'response',
		'statement',
		'parameters'
	],
	#category : #'StQuantifiedSelf-Neo4j'
}

{ #category : #'instance creation' }
SqsNeo4jDayWithLinksQuery class >> forDay: aDate [
	^ self new
		statement: 'match (d:Day {name: $name})<-[r]-(n) return n, r, d';
		parameters: (Dictionary newFromPairs: {#name . aDate yyyymmdd});
		yourself.
]

{ #category : #accessing }
SqsNeo4jDayWithLinksQuery class >> forNovember13 [
	<gtExample>
	^ self forDay: (Date fromString: '11/13/2024')
]

{ #category : #converting }
SqsNeo4jDayWithLinksQuery >> asJournalSummary [
	| summaryRel |
	summaryRel := (self relationships
			select: [ :r | (r first at: 'labels') includes: 'Summary' ]) first.
	^ (summaryRel first at: #properties) at: #content
]

{ #category : #actions }
SqsNeo4jDayWithLinksQuery >> asRequestBody [
	^ STONJSON
		toString: (Dictionary
				newFromPairs: {#statement.
						self statement.
						#parameters.
						self parameters})
]

{ #category : #constants }
SqsNeo4jDayWithLinksQuery >> databaseUrl [
	^ 'http://localhost:7474/db/quantified-self/query/v2'
]

{ #category : #views }
SqsNeo4jDayWithLinksQuery >> gtResponseItemsFor: aView [
	<gtView>
	| view |
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
SqsNeo4jDayWithLinksQuery >> hasRows [
	^ self relationships isNotEmpty
]

{ #category : #accessing }
SqsNeo4jDayWithLinksQuery >> parameters [
	^ parameters
]

{ #category : #accessing }
SqsNeo4jDayWithLinksQuery >> parameters: aDictionary [ 
	parameters := aDictionary
]

{ #category : #actions }
SqsNeo4jDayWithLinksQuery >> perform [
	self response
		ifNil: [ response := STONJSON
					fromString: (ZnClient new
							url: self databaseUrl;
							entity: (ZnEntity json: self asRequestBody);
							post) ]
]

{ #category : #views }
SqsNeo4jDayWithLinksQuery >> relationships [
	^ (self response at: #data) at: #values
]

{ #category : #accessing }
SqsNeo4jDayWithLinksQuery >> response [
	^ response
]

{ #category : #accessing }
SqsNeo4jDayWithLinksQuery >> response: anObject [
	response := anObject
]

{ #category : #accessing }
SqsNeo4jDayWithLinksQuery >> statement [
	^ statement
]

{ #category : #accessing }
SqsNeo4jDayWithLinksQuery >> statement: aString [ 
	statement := aString
]
