Class {
	#name : #SqsObsidianVault,
	#superclass : #Object,
	#instVars : [
		'folder',
		'nodes'
	],
	#category : #'StQuantifiedSelf-Base'
}

{ #category : #'instance creation' }
SqsObsidianVault class >> fromFolder: aFolder [
	aFolder exists ifFalse: [ DirectoryDoesNotExist signalWith: aFolder path ].
	^ self new
		folder: aFolder;
		yourself.
]

{ #category : #'instance creation' }
SqsObsidianVault class >> testVault [
	| repoFolder |
	repoFolder := GtGitRepository forClass: self.
	^ self fromFolder: (repoFolder icebergRepository repositoryDirectory / 'vault')
]

{ #category : #accessing }
SqsObsidianVault >> folder [
	^ folder
]

{ #category : #initialization }
SqsObsidianVault >> folder: aFolder [ 
	folder := aFolder
]

{ #category : #view }
SqsObsidianVault >> gtNodesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Nodes';
		priority: 10;
		items: [ self readNodes ];
		column: 'Labels' text: [ :item | item labelsAsString joinUsing: ' ' ];
		column: 'Name' text: [ :item | item name ];
		column: 'Properties' text: [ :item | item properties ]
]

{ #category : #initialization }
SqsObsidianVault >> readNodes [
	nodes := self folder allFiles
			select: [ :file | file contents beginsWith: '---' ]
			thenCollect: [ :file | SqsEntityNode fromMarkdown: file inVault: self ].
	^ nodes
]
