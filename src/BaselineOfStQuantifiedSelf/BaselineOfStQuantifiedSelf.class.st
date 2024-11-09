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
