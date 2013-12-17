from LoadedLookupTable import LoadedLookupTable
import numpy
import unittest

class LoadedLookupTableTest(unittest.TestCase):
  
  @classmethod
  def setUpClass(cls):
    cls.lookup_table = LoadedLookupTable.load()

  def test_known_indices(self):
    self.assertEqual(1738, LoadedLookupTable.PADDING)
    self.assertEqual(1739, LoadedLookupTable.UNKNOWN)
    self.assertEqual(LoadedLookupTable.PADDING, self.lookup_table.query_index('PADDING'))
    self.assertEqual(LoadedLookupTable.UNKNOWN, self.lookup_table.query_index('UNKNOWN'))

    self.assertEqual('PADDING', self.lookup_table.query_word(LoadedLookupTable.PADDING))
    self.assertEqual('UNKNOWN', self.lookup_table.query_word(LoadedLookupTable.UNKNOWN))
    self.assertEqual('UNKNOWN', self.lookup_table.query_word(-1))

    self.assertEqual(1245, self.lookup_table.query_index('0/0/0'))
    self.assertEqual(1642, self.lookup_table.query_index('0th'))
    self.assertEqual(96968, self.lookup_table.query_index('reply'))
    self.assertEqual(LoadedLookupTable.UNKNOWN, self.lookup_table.query_index('wree'))
    self.assertEqual(129975, self.lookup_table.query_index('zygmunt'))

  def test_forward(self):
    embedding_from_index = self.lookup_table.forward(self.lookup_table.query_index('to'))
    embedding_from_word = self.lookup_table.forward('to')
    self.assertTrue(numpy.allclose(embedding_from_index, embedding_from_word))

    embedding0 = self.lookup_table.forward(0)
    self.assertAlmostEqual(-1.03682, embedding0[0])
    self.assertAlmostEqual(1.5799, embedding0[4])
    self.assertAlmostEqual(-0.64853, embedding0[49])

    embedding129999 = self.lookup_table.forward(129999)
    self.assertAlmostEqual(-0.238824, embedding129999[0])
    self.assertAlmostEqual(-1.76695, embedding129999[4])
    self.assertAlmostEqual(-1.4733, embedding129999[49])

if '__main__' == __name__:
  unittest.main()
