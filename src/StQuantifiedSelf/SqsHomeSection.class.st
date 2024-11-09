Class {
	#name : #SqsHomeSection,
	#superclass : #GtHomeMultiCardSection,
	#category : #'StQuantifiedSelf-Base'
}

{ #category : #'*StQuantifiedSelf' }
SqsHomeSection >> getStartedSection [
	<gtHomeSection>
	<gtExample>
	<noTest>
	^ GtHomeMultiCardGetStartedSection new
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
		"pageName: 'Glamorous Toolkit';"
		databaseName: 'Quantified Self Notebook';
		readMoreToolbar;
		details: [ :db | 
			| snippets somePages |
			somePages := db pages select: #shouldAppearInIndexOrDailyNotes.
			snippets := somePages flatCollect: #allChildrenDepthFirst.
			'The project diary is expressed as a knowledge base. It documents the progress in '
				, somePages size asString , ' pages containing '
				, snippets size asString , ' snippets of '
				, (snippets groupedBy: #class) size asString , ' different kinds.' ]
				yourself
]

{ #category : #accessing }
SqsHomeSection >> sectionTitle [
	^ 'Smalltalk Quantified Self'
]
