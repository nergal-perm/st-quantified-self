Class {
	#name : #SqsNeo4jEntity,
	#superclass : #Object,
	#instVars : [
		'kind',
		'labels',
		'properties'
	],
	#category : #'StQuantifiedSelf-Neo4j'
}

{ #category : #'instance creation' }
SqsNeo4jEntity class >> from: aDictionary [
	^ (aDictionary includesKey: #labels)
		ifTrue: [ self
				nodeLabeled: (aDictionary at: #labels)
				with: (aDictionary at: #properties) ]
		ifFalse: [ self
				relationTyped: (aDictionary at: #type)
				with: (aDictionary at: #properties) ]
]

{ #category : #'instance creation' }
SqsNeo4jEntity class >> nodeLabeled: anArray with: aDictionary [
	^ self new
		kind: #NODE;
		labels: anArray;
		properties: aDictionary
]

{ #category : #'instance creation' }
SqsNeo4jEntity class >> relationTyped: aString with: aDictionary [
	^ self new
		kind: #RELATIONSHIP;
		labels: (Array with: aString);
		properties: aDictionary 
]

{ #category : #accessing }
SqsNeo4jEntity >> kind [
	^ kind
]

{ #category : #accessing }
SqsNeo4jEntity >> kind: anObject [
	kind := anObject
]

{ #category : #accessing }
SqsNeo4jEntity >> labels [
	^ labels
]

{ #category : #accessing }
SqsNeo4jEntity >> labels: anObject [
	labels := anObject
]

{ #category : #'as yet unclassified' }
SqsNeo4jEntity >> printOn: aStream [
	aStream
		nextPutAll: (self labels joinUsing: ':');
		nextPutAll: ((self properties includesKey: #name)
				ifTrue: [ '(' , (self properties at: #name) asString , ')' ]
				ifFalse: [''])
]

{ #category : #accessing }
SqsNeo4jEntity >> properties [
	^ properties
]

{ #category : #accessing }
SqsNeo4jEntity >> properties: anObject [
	properties := anObject
]
