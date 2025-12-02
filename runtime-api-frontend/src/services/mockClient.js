const cache = new Map()

export async function fetchMockData(fileName) {
  if (!fileName) {
    throw new Error('fileName is required')
  }

  if (cache.has(fileName)) {
    return cache.get(fileName)
  }

  const response = await fetch(`/mock/${fileName}`)
  if (!response.ok) {
    throw new Error(`Failed to load mock data: ${fileName}`)
  }

  const data = await response.json()
  cache.set(fileName, data)
  return data
}

