Class {
	#name : #BaselineOfStQuantifiedSelf,
	#superclass : #BaselineOf,
	#category : #BaselineOfStQuantifiedSelf
}

{ #category : #baseline }
BaselineOfStQuantifiedSelf >> baseline: spec [
	<baseline>
		^ spec for: #common do: [
			spec package: 'StQuantifiedSelf'
		]
]

{ #category : #accessing }
BaselineOfStQuantifiedSelf >> loadLepiter [
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
