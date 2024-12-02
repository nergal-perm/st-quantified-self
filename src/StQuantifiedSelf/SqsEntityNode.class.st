Class {
	#name : #SqsEntityNode,
	#superclass : #Object,
	#instVars : [
		'frontmatter',
		'vault'
	],
	#category : #'StQuantifiedSelf-Nodes'
}

{ #category : #'instance creation' }
SqsEntityNode class >> fromMarkdown: aFile inVault: aVault [
	^ self fromYamlFrontmatter: aFile frontmatter inVault: aVault
]

{ #category : #'instance creation' }
SqsEntityNode class >> fromYamlFrontmatter: aFrontmatter inVault: aVault [
	^ (self newNodeForFrontmatter: aFrontmatter)
		frontmatter: aFrontmatter;
		vault: aVault;
		yourself
]

{ #category : #'instance creation' }
SqsEntityNode class >> newNodeForFrontmatter: aFrontmatter [
	^ self nodeByLabel: aFrontmatter 
]

{ #category : #'instance creation' }
SqsEntityNode class >> nodeByLabel: aFrontmatter [
	| nodeTypes requestedType |
	nodeTypes := {'Day' -> [ SqsDayNode new ]} asDictionary.
	requestedType := (aFrontmatter at: #labels) last.
	^ (nodeTypes includesKey: requestedType)
		ifTrue: [ (nodeTypes at: requestedType) value ]
		ifFalse: [ SqsEntityNode new ]
]

{ #category : #accessing }
SqsEntityNode >> frontmatter: aFrontmatter [ 
	frontmatter := aFrontmatter
]

{ #category : #accessing }
SqsEntityNode >> labelsAsString [
	^ frontmatter at: #labels
]

{ #category : #accessing }
SqsEntityNode >> name [
	^ frontmatter at: #title
]

{ #category : #accessing }
SqsEntityNode >> properties [
	^ (frontmatter includesKey: #properties) ifFalse: ['{}'] ifTrue: ['{ something }']
]

{ #category : #accessing }
SqsEntityNode >> vault: aVault [ 
	vault := aVault
]
