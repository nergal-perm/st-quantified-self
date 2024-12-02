Extension { #name : #AbstractFileReference }

{ #category : #'*StQuantifiedSelf' }
AbstractFileReference >> frontmatter [
	| fileLines frontmatterLines |
	fileLines := self contents lines indexOf: '---' startingAt: 2.
	frontmatterLines := (self contents lines takeFirst: fileLines - 1) allButFirst
			joinUsing: String cr.
	^ (YAMLParser parse: frontmatterLines) object
]
