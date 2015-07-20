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


def set_load_type(metadata):
    """
    Determine what the load type should be from metadata.  Set it.

    Also corrects problematic metadata and data URLs (when '; charset') slipped
    in without a slash before.
    """
    data_type = metadata['data'].get('type')
    if data_type == 'csv':
        pass
    elif data_type == 'shapefile':
        metadata['load'] = 'ogr2ogr'
    else:
        data_type = data_type.split(';')[0]
        if data_type in (u'application/pdf', 'pdf'):
            metadata['load'] = 'pdftotext'
        elif data_type in (u'application/xml', 'xml'):
            metadata['load'] = 'TODO: xml'
        elif data_type in (u'vnd.ms-excel', 'xls', 'xlsx'):
            metadata['load'] = 'TODO: excel'
        elif data_type in (u'application/zip', 'zip'):
            metadata['load'] = 'TODO: zip'
        else:
            metadata['load'] = 'TODO: {}'.format(data_type)
        metadata['data']['@id'] = metadata['data']['@id'].split(';')[0].replace(
            data_type, u'/' + data_type)


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

    if 'type' not in metadata['data']:
        sys.stderr.write('Deleting {} as it has not been inferred recently.\n'.format(path))
        os.unlink(metadata_path)
        return

    set_load_type(metadata)

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

    if 'status' not in metadata:
        metadata['status'] = 'needs review'

    with open(metadata_path, 'w') as new_json_file:
        json.dump(metadata, new_json_file, indent=2, sort_keys=True)

if __name__ == '__main__':
    process(sys.argv[1])
