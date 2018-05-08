double scientificToFloat( const char *str )
{
	double fraction;
	int exponent;
	char buf[256];
	strcpy( buf, str );
	char *token = strtok( buf,"Ee \t\n");
	fraction = atof(token);
	token = strtok( NULL, "Ee \t\n" );
	exponent = atoi( token );

	if( exponent != 0 )
		fraction *= pow(10, exponent);

	return fraction;
}

