'''
update a single existing data.json to new format.
'''

import json
import os
import sys


def generate_schema(table, schema):
    """
    Generate a schema dynamically in cases where it doesn't exist already.
    """
    columns = [u'\t"{}"\t{}'.format(c['name'], c['type']) for c in schema['columns']]
    return u'CREATE TABLE "{table}" (\n{columns}\n);\n'.format(
        table=table, columns=',\n'.join(columns))


def process(path):
    '''
    Process metadata at path
    '''
    if os.path.exists(os.path.join(path, 'schema.sql')):
        sys.stderr.write('Skipping {} as it is custom or already updated.\n'.format(path))
        return

    metadata_path = os.path.join(path, 'data.json')
    with open(metadata_path, 'r') as old_json_file:
        metadata = json.load(old_json_file)

    if isinstance(metadata['data'], basestring):
        sys.stderr.write('Skipping {} as it is custom or already updated.\n'.format(path))
        return

    data_type = metadata['data']['type']
    if data_type == 'csv':
        pass
    elif data_type == 'shapefile':
        metadata['load'] = 'ogr2ogr'
    else:
        import pdb
        pdb.set_trace()

    if '@id' in metadata['data']:
        metadata['data'] = metadata['data']['@id']

    if 'tableName' in metadata:
        metadata['table'] = metadata.pop('tableName')

    if 'schema' in metadata:
        if 'columns' in metadata['schema']:
            schema_text = generate_schema(metadata['table'], metadata.pop('schema'))
            schema_path = os.path.join(path, 'schema.sql')
            with open(schema_path, 'w') as schema_file:
                schema_file.write(schema_text)
        else:
            del metadata['schema']

    if 'schemaName' in metadata:
        metadata['schema'] = metadata.pop('schemaName')

    with open(metadata_path, 'w') as new_json_file:
        json.dump(metadata, new_json_file, indent=2, sort_keys=True)

if __name__ == '__main__':
    process(sys.argv[1])
