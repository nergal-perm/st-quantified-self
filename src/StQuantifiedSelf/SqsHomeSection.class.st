Class {
	#name : #SqsHomeSection,
	#superclass : #GtHomeMultiCardSection,
	#category : #'StQuantifiedSelf-Base'
}

{ #category : #accessing }
SqsHomeSection >> defaultPriority [
	^ 100
]

{ #category : #accessing }
SqsHomeSection >> projectDiary [
	<gtSectionCard>
	<gtExample>
	<noTest>
	^ GtHomeCard lepiterBaseWithTableOfContents
		title: 'Project diary';
		description: 'Track progress in an interactive journal';
		priority: 10;
		databaseName: 'Quantified Self Notebook';
		editableToolbar;
		details: [ :db | 'Some details here' ];
		yourself
]

{ #category : #accessing }
SqsHomeSection >> sectionTitle [
	^ 'Smalltalk Quantified Self'
]
