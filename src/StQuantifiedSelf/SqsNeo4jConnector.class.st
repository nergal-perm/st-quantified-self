Class {
	#name : #SqsNeo4jConnector,
	#superclass : #Object,
	#instVars : [
		'statement'
	],
	#category : #'StQuantifiedSelf-Neo4j'
}

{ #category : #example }
SqsNeo4jConnector class >> basicFoodGraph [
	<gtExample>
	^ self new
		statement: self basicFoodStatement;
		perform;
		yourself.
]

{ #category : #example }
SqsNeo4jConnector class >> basicFoodStatement [
	^ 'CREATE 
	(today:Day {date:date("2024-11-17")}),
	(lunch:Meal {type:"lunch"}),
	(dinner:Meal {type:"dinner"}),
	(lunch)-[:OCCURS_ON {time: "14:00"}]->(today),
	(dinner)-[:OCCURS_ON {time: "20:00"}]->(today),
	(bugulme_cooked:Dish:Instance {name:"bugulme"}),
	(bugulme_cooked)-[:ATE_AT {unit: "gram", amount:250}]->(lunch),
	(bugulme_cooked)-[:ATE_AT {unit: "ratio", amount: 1.0/3.0}]->(dinner),
	(bugulme_cooked)-[:COOKED_ON]->(today),
	(eggplant_inst:Ingredient:Instance {name: "Eggplant", unit: "gram", amount: 300}),
	(chicken_inst:Ingredient:Instance {name: "Chicken", unit: "gram", amount: 200}),
	(eggplant_inst)-[:USED_TO_COOK]->(bugulme_cooked),
	(chicken_inst)-[:USED_TO_COOK]->(bugulme_cooked),
	(eggplant:Ingredient {name: "Eggplant", type: "Vegetable"}),
	(eggplant_inst)-[:INSTANCE_OF]->(eggplant),
	(eggplant_nv:NutritionalValue {unit: "gram", carbohydrates: 62.0/100.0, sugar: 18.0/100.0}),
	(eggplant_nv)-[:NUTRITIONAL_VALUE]->(eggplant),
	(chicken:Ingredient {name: "Chicken", type: "Meat"}),
	(chicken_inst)-[:INSTANCE_OF]->(chicken),
	(chicken_nv:NutritionalValue {unit: "gram", fat: 8.0/100.0, protein: 18.0/100.0}),
	(chicken_nv)-[:NUTRITIONAL_VALUE]->(chicken)'
]

{ #category : #example }
SqsNeo4jConnector class >> clearDatabase [
	<gtExample>
	^ self new 
		statement: 'MATCH (n) DETACH DELETE n';
		perform;
		yourself.
]

{ #category : #'as yet unclassified' }
SqsNeo4jConnector class >> totalCarbs [
	^ 'MATCH (lunch:Meal {type: "dinner"})<-[r:ATE_AT]-(d:Dish:Instance {name: "bugulme"})<-[:USED_TO_COOK]-(ingredient:Ingredient)-[:INSTANCE_OF]->(baseIngredient:Ingredient)<-[:NUTRITIONAL_VALUE]-(nutritionalValue:NutritionalValue)
WITH SUM(ingredient.amount * nutritionalValue.carbohydrates) AS totalCarbs, r, SUM(ingredient.amount) AS totalAmount
RETURN totalCarbs, r.amount, totalAmount,
CASE r.unit 
    WHEN "ratio" THEN totalCarbs * r.amount
    ELSE totalCarbs * (1.0 * r.amount / totalAmount)
END AS result'
]

{ #category : #example }
SqsNeo4jConnector class >> totalCarbsAmount [
	<gtExample>
	^ self new
		statement: self totalCarbs;
		perform;
		yourself.
]

{ #category : #view }
SqsNeo4jConnector >> gtStatementFor: aView [
	<gtView>
	^ aView explicit
		title: 'Statement';
		priority: 10;
		stencil: [ self statementEditorWidget ];
		actionButtonIcon: BrGlamorousVectorIcons accept
			tooltip: 'Save statement'
			action: [ :aToggle :aTab | 
				statement := aTab viewContentElement children first text asString ]
]

{ #category : #initialization }
SqsNeo4jConnector >> initialize [
	statement := 'RETURN 1'
]

{ #category : #'as yet unclassified' }
SqsNeo4jConnector >> perform [
	^ self request post
]

{ #category : #'as yet unclassified' }
SqsNeo4jConnector >> request [
	| request |
	request := Dictionary new at: 'statement' put: self statement.
	^ ZnClient new
		url: 'http://localhost:7474/db/quantified-self/query/v2';
		entity: (ZnEntity json: (STONJSON toString: request))
]

{ #category : #accessing }
SqsNeo4jConnector >> statement [
	^ statement
]

{ #category : #accessing }
SqsNeo4jConnector >> statement: anObject [
	^ statement := anObject
]

{ #category : #widgets }
SqsNeo4jConnector >> statementEditorWidget [
	| snippetViewModel snippet |
	snippet := LeShellScriptSnippet code: statement.
	snippetViewModel := snippet asSnippetViewModel.
	snippetViewModel coderViewModel
		addShortcut: (BrEditorShortcut lineEnding
				combination: (LeSnippetElement keyboardShortcut: #NewLine)).
	snippetViewModel coderViewModel
		addShortcut: (BlShortcutWithAction new
				combination: BlKeyCombination primaryS;
				action: [ :anEvent | statement := anEvent currentTarget text asString ]).
	^ ((snippetViewModel snippetView needsEmbellishments: false) asElement
		snippetViewModel: snippetViewModel)
		vMatchParent;
		hExact: 650
]
