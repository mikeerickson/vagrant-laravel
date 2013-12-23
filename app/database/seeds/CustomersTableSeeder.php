<?php

class CustomersTableSeeder extends Seeder {

	public function run()
	{
		// Uncomment the below to wipe the table clean before populating
		DB::table('customers')->truncate();

		$customers = array(
			[
				"name" => "codedungeon",
				"address" => "15611 Mayflower Lane",
				"city" => "Huntington Beach",
				"state" => "CA",
				"zip" => "92647",
				"fname" => "Mike",
				"lname" => "Erickson",
				"created_at" => new DateTime(),
				"updated_at" => new DateTime()
			]
		);

		// Uncomment the below to run the seeder
		DB::table('customers')->insert($customers);
	}

}
