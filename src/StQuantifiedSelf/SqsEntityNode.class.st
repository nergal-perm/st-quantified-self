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
