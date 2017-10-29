---
layout: specs
---
# CF-JSON specification
Version 0.2

## 1. Introduction

### 1.1 Purpose
CF-JSON is a JSON format primarily intended for encoding climate and weather data. The format supports data defined on arbitrary spatial domains such as grids, at points or along tracks. The format is self describing, meaning that all necessary spatial and temporal coordinate data is carried within the overall data object itself.

### 1.2 Relationship with CF-conventions and NetCDF
CF-JSON is an application of [NetCDF CF-conventions](http://cfconventions.org) to the JSON format. It uses all of the fundamental data structures and components of CF-NetCDF. CF-JSON is capable of expressing the data in any CF compliant NetCDF file.

### 1.3 Definitions
The terms JSON, object, member, name, value, array number, true, false and null all correspond to the terms definied in [RFC7159](https://tools.ietf.org/html/rfc7159).
The terminology defined in Section 1.2 of the NetCDF CF-conventions document is also used here for specific components of data structures or spatial entities.

## 2. CF-JSON object
A CF-JSON object represents a set of data referenced in space and (optionally) time. Data is specified as `variables` on defined `dimensions`. Global or variable `attributes` can be attached to the overall CF-JSON object or to individual `variables`. A CF-JSON object MUST contain `dimensions` and `variables` objects and optionally a global `attributes` object.

Example CF-JSON object for some wind data data arranged on a grid:

``` Javascript
{
    "attributes": {
        "source": "cf-json.org",
        "description": "Example wind data on a grid",
        "timestamp": "2000-01-01T00:00:00Z"
    },
    "dimensions": {
        "latitude": 8,
        "longitude": 10
    },
    "variables": {
        "longitude": {
            "shape": ["longitude"],
            "type": "float",
            "attributes": {
                "units": "degrees_east"
            },
            "data": [ 0.2,  0.4,  0.6,  0.8,  1.0,  1.2,  1.4,  1.6,  1.8,  2.0]
        },
        "latitude": {
            "shape": ["latitude"],
            "type": "float",
            "attributes": {
                "units": "degrees_north"
            },
            "data":[ 30.2,  30.4,  30.6,  30.8,  31.0,  31.2,  31.4,  31.6]
        },
        "wind_east": {
            "shape": ["latitude", "longitude"],
            "type": "float",
            "attributes": {
                "units": "ms^{-1}",
                "long_name": "Easterly component of wind",
                "standard_name": "eastward_wind"
            },
            "data":[
                [ 5.3,  2.2,  2.2,  5.2,  1.6,  5.2,  6.7,  9.9,  8.4,  1.5],
                [ 7.1,  1.9,  7.8,  6.8,  1.7,  2.3,  6.8,  2.6,  3.5,  4.5],
                [ 1.5,  4.4,  5.9,  0.3,  7.6,  1.0,  6.6,  0.8,  2.8,  3.0],
                [ 4.3,  4.0,  5.3,  1.1,  0.6,  7.9,  8.3,  9.0,  6.9,  3.5],
                [ 5.1,  6.6,  4.5,  4.8,  2.7,  7.3,  9.3,  1.2,  4.2,  1.9],
                [ 9.3,  9.1,  5.5,  5.2,  2.5,  0.1,  6.4,  9.5,  5.6,  5.9],
                [ 0.1,  5.2,  0.8,  8.4,  3.8,  3.1,  8.7,  0.7,  1.0,  2.8],
                [ 7.5,  2.7,  5.9,  6.8,  4.2,  9.1,  9.8,  4.7,  1.8,  6.9]
            ]
        },
        "wind_north": {
            "shape": ["latitude", "longitude"],
            "type": "float",
            "attributes": {
                "units": "ms^{-1}",
                "long_name": "Northerly component of wind",
                "standard_name": "northward_wind"
            },
            "data": [
                [ 8.9,  2.1,  9.0,  6.0,  9.2,  8.6,  7.3,  7.2,  5.6,  6.0],
                [ 8.4,  9.1,  0.2,  9.2,  6.4,  9.4,  6.3,  4.1,  1.3,  3.7],
                [ 4.3,  5.3,  2.3,  8.5,  9.1,  9.8,  7.4,  2.5,  9.0,  0.9],
                [ 8.1,  5.8,  2.7,  2.9,  7.6,  5.5,  4.8,  5.0,  3.9,  9.6],
                [ 5.9,  7.2,  3.5,  4.7,  8.4,  9.3,  0.9,  9.6,  5.5,  5.8],
                [ 7.9,  6.1,  2.2,  9.6,  9.8,  7.5,  0.1,  6.6,  0.0,  2.7],
                [ 7.0,  6.0,  6.5,  1.1,  8.0,  9.0,  9.7,  1.6,  5.0,  6.6],
                [ 6.0,  4.4,  5.0,  8.6,  5.6,  3.5,  1.9,  2.3,  7.2,  3.1]
            ]
        }
    }
}
```

### 2.1 Attributes
The `attributes` object contains arbitrary global attributes as its key:value members. These attributes can express any relevant information about the overall dataset. The attributes object can contain further nested objects.

### 2.2 Dimensions
The `dimensions` object has dimension id:size as its key:value members. All dimensions MUST be declared in the dimensions object, if they are used in any variables. Not all dimensions need to be used in any given variable. The dimensions length with correspond to the size of the data array in that dimension.

### 2.3 Variables
The variables definition object has variable id:object as its key:value members. Each variable object MUST include `shape`,`attributes` and `data` objects. The `shape` field is an array of dimension IDs which correspond to the array ordering of the variable data. It is recommended but not mandatory to use [COARDS convention](http://ferret.pmel.noaa.gov/Ferret/documentation/coards-netcdf-conventions) dimension ordering for spatial and temporal dimensions which TZYX. A variable can have no dimensions if it has only a single numeric or string value, in which case the dimensions should be specified as `null`.

It is recommended but not mandatory to include the [CF-conventions standard name](http://cfconventions.org/Data/cf-standard-names/27/build/cf-standard-name-table.html) as a variable attribute inside the `attributes` object. It is recommended to include the variable units in the attributes. Latex formatting the preferred means to indicate exponents.

A `type` field representing the original data type can also be included and is required for a reversable transformation back to NetCDF.

#### 2.3.1 Data object
The `data` sub-field contains the actual data for each variable. The data value itself must be a single value (for no dimensions) or array with the same number of dimensions as the variable definition and with the same array ordering as the variable dimensions.

Example:
```Javascript
{
    ...
    "variables": {
        "tmp2m": {
            "shape": ["time","latitude","longitude"],
            "type": "float",
            "data": [
                [[1.2,3.4,5.6 ...],
                [2.3,6.5,8.7 ...],
             ...
            ],
        }
    }
}
```
The value at `object["variables"]["tmp2m"]["data"][k,j,i]` is at `time[k]`, `latitude[j]` and `longitude[i]`.

#### 2.3.2 Missing data
Missing data can either be expressed as `null` or given a specific `missing_value` numeric or string value which is defined in the attributes. `NaN` should NOT be used as it is not JSON compliant.

Example:
``` Javascript
{
    ...
    "variables": {
        "tmp2m": {
            "shape": ["time","latitude","longitude"],
            "missing_value": -9999,
            "data": [
                [[1.2,3.4,-9999 ...],
                [2.3,-9999,8.7 ...],
             ...
            ],
        ]
    ...
}
```



#### 2.3.3 Data precision
The number of significant figures used to express numeric data values should be sensible for data efficiency and readability. However the decimal precision of the data itself does not imply its underlying accuracy or precision. If a reversable transformation from NetCDF is required, the number of decimals must support the precision of the data type.

#### 2.3.4 Time
Time data should be expressed as numeric values relative to a start time as in CF-conventions OR as an array of [ISO8601](https://www.iso.org/iso-8601-date-and-time-format.html) strings.

Example:
```Javascript
{
    ...   
    "variables": {
        "time": {
            "shape": ["time"],
            "type": "float",
            "attributes": {
                "units": "days since 2000-01-01"
            },
            "data": [0.0, 1.0, 2.0]
        }
    },
    
}
```
is the same as:
```Javascript
{
    ...
    "variables": {
        "time": {
            "shape": ["time"],
            "type": "string",
            "attributes": {
                "units": "ISO8601 datetimes"
            },
            "data": [
                "2000-01-01T00:00:00Z",
                "2000-01-02T00:00:00Z",
                "2000-01-03T00:00:00Z"
            ]
        }
    },
}
```

## 3. Recommendations

### 3.1 Units
Currently there is no specification around units but is recommended to use [udunits](https://www.unidata.ucar.edu/software/udunits/) compatible identifiers.
