Class {
	#name : #BaselineOfStQuantifiedSelf,
	#superclass : #BaselineOf,
	#category : #BaselineOfStQuantifiedSelf
}

{ #category : #accessing }
BaselineOfStQuantifiedSelf class >> loadLepiter [
	IceRepository registry
		detect: [ :aRepository | aRepository name = 'st-quantified-self' ]
		ifFound: [ :aRepository | 
			| defaultDatabase currentProperties |
			defaultDatabase := LeDatabasesRegistry defaultLogicalDatabase.
			currentProperties := defaultDatabase properties.
			currentProperties
				addRegisteredDirectory: aRepository repositoryDirectory / 'lepiter'.
			defaultDatabase reload ]
		ifNone: [ self inform: 'Repository not found.' ]
]

{ #category : #baseline }
BaselineOfStQuantifiedSelf >> baseline: spec [
	<baseline>
		^ spec for: #common do: [
			spec package: 'StQuantifiedSelf'
		]
]
