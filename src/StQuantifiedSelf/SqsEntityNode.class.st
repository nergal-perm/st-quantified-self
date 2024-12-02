Class {
	#name : #SqsEntityNode,
	#superclass : #Object,
	#instVars : [
		'frontmatter',
		'vault'
	],
	#category : #'StQuantifiedSelf-Base'
}

{ #category : #'instance creation' }
SqsEntityNode class >> fromMarkdown: aFile inVault: aVault [
	| fileLines frontmatter|
	fileLines := aFile contents lines indexOf: '---' startingAt: 2.
	frontmatter := (aFile contents lines takeFirst: fileLines - 1) allButFirst
		joinUsing: String cr.
	^ self fromYamlFrontmatter: frontmatter inVault: aVault
]

{ #category : #'instance creation' }
SqsEntityNode class >> fromYamlFrontmatter: aFrontmatter inVault: aVault [
	^ self new
		frontmatter: aFrontmatter;
		vault: aVault;
		yourself.
]

{ #category : #accessing }
SqsEntityNode >> frontmatter: aFrontmatter [ 
	frontmatter := (YAMLParser parse: aFrontmatter) object
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
